#import "TKSInputSectionVM.h"

#import "TKSDataProvider.h"
#import "TKSSuggestCellVM.h"

@interface TKSInputSectionVM ()

@property (nonatomic, copy, readwrite) NSArray<TKSSuggestCellVM *> *cellVMs;

@end

@implementation TKSInputSectionVM

- (instancetype)initWithModel:(id)model
{
	self = [super initWithModel:model];
	if (self == nil) return nil;

	_shouldSearchTaxiSignal = [self rac_signalForSelector:@checkselector(self, searchTaxiFromSuggest:, toSuggest:)];

	[self setupSuggesterAndHistory];

	return self;
}

- (void)searchTaxiFromSuggest:(TKSSuggest *)fromSuggest toSuggest:(TKSSuggest *)toSuggest
{
}

- (void)setupSuggesterAndHistory
{
	@weakify(self);

	RACSignal *suggesterSignal = [RACSignal merge:@[
		RACObserve(self.model.fromSearchVM, suggests),
		RACObserve(self.model.toSearchVM, suggests)
	]];

	// Setup suggests
	[[[suggesterSignal
		filter:^BOOL(NSArray *suggests) {
			return suggests.count > 0;
		}]
		deliverOnMainThread]
		subscribeNext:^(NSArray<TKSSuggest *> *suggests) {
			@strongify(self);

			[self loadCellVMsForSuggests:suggests type:TKSCellTypeSuggest];
			[self reloadSection];
		}];

	// Setup history
	[[[suggesterSignal
		filter:^BOOL(NSArray *suggests) {
			return suggests.count == 0;
		}]
		deliverOnMainThread]
		subscribeNext:^(id _) {
			@strongify(self);

			[self loadHistory];
			[self reloadSection];
		}];

	// Setup location
	RACSignal *didSelectLocationSignal = [RACSignal merge:@[
		self.model.fromSearchVM.didSelectLocationSuggestSignal,
		self.model.toSearchVM.didSelectLocationSuggestSignal,
	]];

	[didSelectLocationSignal
		subscribeNext:^(TKSSuggest *suggest) {
			@strongify(self);

			[self switchToNextTextFiledIfNeeded];
			[self startSearchIfNeeded];
		}];
}

- (void)switchToNextTextFiledIfNeeded
{
	// Если `А` inputVM активен, переключаем на `Б` inputVM
	// Если `Б` inputVM активен, смотрим, если `А` - пустой, то переключаем на него, если полный, то готовы искать такси
	if (self.model.currentSearchVM == self.model.fromSearchVM)
	{
		self.model.fromSearchVM.active = NO;
		self.model.toSearchVM.active = YES;
	}
	else
	{
		if (!self.model.fromSearchVM.dbObject)
		{
			self.model.fromSearchVM.active = YES;
			self.model.toSearchVM.active = NO;
		}
	}
}

- (void)startSearchIfNeeded
{
	if (self.model.fromSearchVM.dbObject && self.model.toSearchVM.dbObject)
	{
		[self searchTaxiFromSuggest:self.model.fromSearchVM.dbObject
						  toSuggest:self.model.toSearchVM.dbObject];
	}
}

- (void)didSelectCellVMAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row >= self.cellVMs.count) return;

	// Analytics
	TKSSuggestCellVM *cellVM = [self.cellVMs objectAtIndex:indexPath.row];
	[self trackSuggestCellVM:cellVM];

	// Do what we need

	TKSSuggest *suggest = [cellVM suggest];
	if (cellVM.type == TKSCellTypeSuggest)
	{
		[self processSuggest:suggest];
	}
	else
	{
		[self processHistorySuggest:suggest];
	}
}

- (void)processSuggest:(TKSSuggest *)suggest
{
	NSString *suggestText = suggest.text;

	BOOL isSuggestStreet = [suggest.hintLabel isEqualToString:@"street"];
	if (isSuggestStreet)
	{
		self.model.currentSearchVM.text = [suggestText stringByAppendingString:@", "];
		self.model.currentSearchVM.dbObject = suggest;
	}
	else
	{
		[self saveSuggestToHistory:suggest];
	}

	if (!isSuggestStreet)
	{
		[self processHistorySuggest:suggest];
	}
}

- (void)processHistorySuggest:(TKSSuggest *)historySuggest
{
	self.model.currentSearchVM.text = historySuggest.text;
	self.model.currentSearchVM.dbObject = historySuggest;

	[self switchToNextTextFiledIfNeeded];
	[self startSearchIfNeeded];
}

- (void)saveSuggestToHistory:(TKSSuggest *)suggest
{
	[[TKSDataProvider sharedProvider] addSuggestToHistory:suggest];
}

- (void)loadHistory
{
	[self loadCellVMsForSuggests:[TKSDataProvider sharedProvider].historyList type:TKSCellTypeHistory];
}

- (void)loadCellVMsForSuggests:(NSArray<TKSSuggest *> *)suggests type:(TKSCellType)type
{
	self.cellVMs = [suggests.rac_sequence
		map:^TKSBaseVM *(TKSSuggest *suggest) {
			return [[TKSSuggestCellVM alloc] initWithSuggest:suggest type:type];
		}].array;
}

- (void)clearSection
{
	_cellVMs = @[];
}

- (NSString *)headerTitleLeft
{
	return @"";
}

- (NSString *)headerTitleRight
{
	return @"";
}

// MARK: Analytics

- (void)trackSuggestCellVM:(TKSSuggestCellVM *)cellVM
{
	NSString *analyticsType = cellVM.type == TKSCellTypeSuggest
		? @"suggest"
		: @"history";

	[self trackSuggest:cellVM.suggest analyticsType:analyticsType];
}

- (void)trackSuggest:(TKSSuggest *)suggest analyticsType:(NSString *)analyticsType
{
	if (!suggest) return;

	NSString *type = self.model.currentSearchVM == self.model.fromSearchVM
		? @"from"
		: @"to";

	NSString *qString = self.model.currentSearchVM.text.length > 0
		? self.model.currentSearchVM.text
		: @"";

	NSDictionary *body = @{
		@"item_id" : suggest.id,
		@"q" : qString,
		@"type" : type,
		@"source" : @"q"
	};

	NSString *aType = [analyticsType stringByAppendingString:@"-select"];
	[[TKSDataProvider sharedProvider] sendAnalyticsForType:aType body:body];
}

@end
