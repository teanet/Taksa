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

	_orderMode = TKSOrderModeHistory;

	[self setupReactiveStuff];

	return self;
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[self setupSuggestsAndHistory];
	[self setupScroll];
	[self setupOrderModes];

	[[self.taxiListVM.didSelectTaxiSignal
		ignore:nil]
		subscribeNext:^(TKSTaxiRow *taxiRow) {
			@strongify(self);

			[self trackTaxiRow:taxiRow];
			[[TKSDataProvider sharedProvider].taxiProcessor processTaxiRow:taxiRow];
		}];

	[self.inputVM.didPressReturnButtonSignal
		subscribeNext:^(id _) {
			@strongify(self);

			[self startSearchIfNeeded];
		}];
}

- (void)setupSuggestsAndHistory
{
	@weakify(self);

	RACSignal *didSelectSuggestSignal = [self.suggestListVM.didSelectSuggestSignal
		filter:^BOOL(TKSSuggest *suggest) {
			NSString *suggestText = suggest.text;

			BOOL isSuggestStreet = [suggest.hintLabel isEqualToString:@"street"];
			if (isSuggestStreet)
			{
				self.inputVM.currentSearchVM.text = [suggestText stringByAppendingString:@", "];
				self.inputVM.currentSearchVM.dbObject = suggest;
			}
			else
			{
				[self saveSuggestToHistory:suggest];
			}

			[self trackSuggest:suggest analyticsType:@"suggest"];

			return !isSuggestStreet;
		}];

	RACSignal *didSelectLocationSignal = [RACSignal merge:@[
		self.inputVM.fromSearchVM.didSelectLocationSuggestSignal,
		self.inputVM.toSearchVM.didSelectLocationSuggestSignal,
	]];

	[didSelectLocationSignal
		subscribeNext:^(TKSSuggest *suggest) {
			@strongify(self);

			[self switchToNextTextFiledIfNeeded];
			[self startSearchIfNeeded];
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
			self.inputVM.currentSearchVM.dbObject = suggest;

			[self switchToNextTextFiledIfNeeded];
			[self startSearchIfNeeded];
		}];
}

- (void)setupScroll
{
	@weakify(self);

	[[RACSignal merge:@[_suggestListVM.didScrollSignal, _historyListVM.didScrollSignal]]
		subscribeNext:^(id _) {
			@strongify(self);

			self.inputVM.fromSearchVM.active = NO;
			self.inputVM.toSearchVM.active = NO;
		}];
}

- (void)setupOrderModes
{
	@weakify(self);

	[self.inputVM.didBecomeEditingSignal subscribeNext:^(id x) {
		@strongify(self);

		TKSOrderMode mode = self.inputVM.currentSearchVM.suggests.count > 0 ? TKSOrderModeSuggest : TKSOrderModeHistory;
		self.orderMode = mode;
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
}

- (void)clearSearchResultForCurrentSearchVM
{
	self.inputVM.currentSearchVM.dbObject = nil;
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
	@weakify(self);

	if (self.inputVM.fromSearchVM.dbObject && self.inputVM.toSearchVM.dbObject)
	{
		[[self fetchTaxiList]
			subscribeError:^(NSError *error) {
				@strongify(self);

				TKSOrderMode mode = self.inputVM.currentSearchVM.suggests.count > 0 ? TKSOrderModeSuggest : TKSOrderModeHistory;
				self.orderMode = mode;
			}];
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

// MARK: Analytics

- (void)trackSuggest:(TKSSuggest *)suggest analyticsType:(NSString *)analyticsType
{
	if (!suggest) return;

	NSString *type = self.inputVM.currentSearchVM == self.inputVM.fromSearchVM
		? @"from"
		: @"to";

	NSString *qString = self.inputVM.currentSearchVM.text.length > 0
		? self.inputVM.currentSearchVM.text
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

- (void)trackTaxiRow:(TKSTaxiRow *)taxiRow
{
	if (!taxiRow) return;

	NSDictionary *body = @{
		@"search_id" : taxiRow.searchId,
		@"operator_id" : taxiRow.id,
	};

	[[TKSDataProvider sharedProvider] sendAnalyticsForType:@"taxi-select" body:body];
}

@end
