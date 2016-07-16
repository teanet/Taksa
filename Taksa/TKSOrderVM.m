#import "TKSOrderVM.h"

#import "TKSTaxiSection.h"
#import "TKSDataProvider.h"

@interface TKSOrderVM ()

@property (nonatomic, assign) TKSOrderMode orderMode;

@end

@implementation TKSOrderVM

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM
{
	self = [super init];
	if (self == nil) return nil;

	_taxiListVM = [[TKSTaxiListVM alloc] init];
	_suggestListVM = [[TKSSuggestListVM alloc] init];
	_historyListVM = [[TKSHistoryListVM alloc] init];
	_inputVM = inputVM ?: [[TKSInputVM alloc] init];

	_orderMode = TKSOrderModeSearch;

	[self setupReactiveStuff];

	return self;
}

- (void)setupReactiveStuff
{
	@weakify(self);

	RACSignal *didSelectSuggestSignal = [self.suggestListVM.didSelectSuggestSignal
		filter:^BOOL(TKSSuggest *suggest) {
			NSString *suggestText = suggest.text;

			BOOL isSuggestStreet = [suggest.hintLabel isEqualToString:@"street"];
			if (isSuggestStreet)
			{
				self.inputVM.currentSearchVM.text = [suggestText stringByAppendingString:@", "];
				[self setSearchResultForCurrentSearchVM:suggest];
			}
			else
			{
				[self saveSuggestToHistory:suggest];
			}

			[self trackSuggest:suggest analyticsType:@"suggest"];

			return !isSuggestStreet;
		}];

	RACSignal *didSelectHistorySignal = [self.historyListVM.didSelectSuggestSignal
		doNext:^(TKSSuggest *suggest) {
			@strongify(self);

			[self trackSuggest:suggest analyticsType:@"history"];
		}];

	[[RACSignal merge:@[didSelectSuggestSignal, didSelectHistorySignal]]
		subscribeNext:^(TKSSuggest *suggest) {
			@strongify(self);

			self.inputVM.currentSearchVM.text = suggest.text;
			[self setSearchResultForCurrentSearchVM:suggest];
			[self switchToNextTextFiledIfNeeded];
			[self startSearchIfNeeded];
		}];

	[[RACSignal merge:@[_suggestListVM.didScrollSignal, _historyListVM.didScrollSignal]]
		subscribeNext:^(id _) {
			@strongify(self);

			self.inputVM.fromSearchVM.active = NO;
			self.inputVM.toSearchVM.active = NO;
		}];

	[self.inputVM.didBecomeEditingSignal subscribeNext:^(id x) {
		@strongify(self);

		self.orderMode = TKSOrderModeSearch;
	}];

	[[[RACObserve(self.taxiListVM, data)
		ignore:nil]
		filter:^BOOL(NSArray *a) {
			return a.count > 0;
		}]
		subscribeNext:^(id _) {
			@strongify(self);

			self.orderMode = TKSOrderModeTaxiList;
		}];

	[[self.taxiListVM.didSelectTaxiSignal
		ignore:nil]
		subscribeNext:^(TKSTaxiRow *taxiRow) {
			@strongify(self);

			[self trackTaxiRow:taxiRow];
		}];
}

- (void)trackSuggest:(TKSSuggest *)suggest analyticsType:(NSString *)analyticsType
{
	if (!suggest) return;

	NSString *type = self.inputVM.currentSearchVM == self.inputVM.fromSearchVM
		? @"from"
		: @"to";

	NSDictionary *body = @{
		@"item_id" : suggest.id,
		@"q" : self.inputVM.currentSearchVM.text,
		@"type" : type,
		@"source" : @"q"
	};

	NSString *aType = [analyticsType stringByAppendingString:@"-select"];
	[[TKSDataProvider sharedProvider] sendAnalyticsForType:aType body:body];
}

- (void)trackTaxiRow:(TKSTaxiRow *)taxiRow
{
	if (!taxiRow) return;

	NSDictionary *body = @{
		@"search_id" : taxiRow.searchId,
		@"operator_id" : taxiRow.id,
	};

	[[TKSDataProvider sharedProvider] sendAnalyticsForType:@"taxi-select" body:body];
}

- (void)clearSearchResultForCurrentSearchVM
{
	if (self.inputVM.currentSearchVM == self.inputVM.fromSearchVM)
	{
		self.inputVM.fromSearchVM.dbObject = nil;
	}
	else
	{
		self.inputVM.toSearchVM.dbObject = nil;
	}
}

- (void)setSearchResultForCurrentSearchVM:(TKSSuggest *)suggest
{
	if (self.inputVM.currentSearchVM == self.inputVM.fromSearchVM)
	{
		self.inputVM.fromSearchVM.dbObject = suggest;
	}
	else
	{
		self.inputVM.toSearchVM.dbObject = suggest;
	}
}

- (void)saveSuggestToHistory:(TKSSuggest *)suggest
{
	[[TKSDataProvider sharedProvider] addSuggestToHistory:suggest];
	[self.historyListVM loadHistory];
}

- (void)switchToNextTextFiledIfNeeded
{
	// Если `А` inputVM активен, переключаем на `Б` inputVM
	// Если `Б` inputVM активен, смотрим, если `А` - пустой, то переключаем на него, если полный, то готовы искать такси
	if (self.inputVM.currentSearchVM == self.inputVM.fromSearchVM)
	{
		self.inputVM.fromSearchVM.active = NO;
		self.inputVM.toSearchVM.active = YES;
	}
	else
	{
		if (!self.inputVM.fromSearchVM.dbObject)
		{
			self.inputVM.fromSearchVM.active = YES;
			self.inputVM.toSearchVM.active = NO;
		}
	}
}

- (void)startSearchIfNeeded
{
	if (self.inputVM.fromSearchVM.dbObject && self.inputVM.toSearchVM.dbObject)
	{
		[[[self fetchTaxiList] publish] connect];
	}
}

- (void)registerTaxiTableView:(UITableView *)tableView
{
	[self.taxiListVM registerTableView:tableView];
}

- (void)registerSuggestTableView:(UITableView *)tableView
{
	[self.suggestListVM registerTableView:tableView];
}

- (RACSignal *)fetchTaxiList
{
	@weakify(self);

	self.orderMode = TKSOrderModeLoading;

	return [[[[TKSDataProvider sharedProvider] fetchTaxiListFromObject:self.inputVM.fromSearchVM.dbObject
															 toObject:self.inputVM.toSearchVM.dbObject]
		delay:1.0]
		doNext:^(NSArray<TKSTaxiSection *> *taxiList) {
			@strongify(self);

			self.taxiListVM.data = taxiList;
		}];
}

@end
