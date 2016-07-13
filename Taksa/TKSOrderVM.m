#import "TKSOrderVM.h"

#import "TKSTaxiSection.h"
#import "TKSDataProvider.h"

@implementation TKSOrderVM

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM
{
	self = [super init];
	if (self == nil) return nil;

	_taxiListVM = [[TKSTaxiListVM alloc] init];
	_suggestListVM = [[TKSSuggestListVM alloc] init];
	_historyListVM = [[TKSHistoryListVM alloc] init];
	_inputVM = inputVM ?: [[TKSInputVM alloc] init];

	[self setupReactiveStuff];

	return self;
}

- (void)setupReactiveStuff
{
	@weakify(self);

	RACSignal *didSelectSuggestSignal = [self.suggestListVM.didSelectSuggestSignal
		doNext:^(TKSSuggest *suggest) {
			NSString *suggestText = suggest.text;

			if ([suggest.hintLabel isEqualToString:@"street"])
			{
				self.inputVM.currentSearchVM.text = [suggestText stringByAppendingString:@", "];
				[self setSearchResultForCurrentSearchVM:suggest];
			}
			else
			{
				[self saveSuggestToHistory:suggest];
			}
		}];

	[[RACSignal merge:@[didSelectSuggestSignal, self.historyListVM.didSelectSuggestSignal]]
		subscribeNext:^(TKSSuggest *suggest) {
			@strongify(self);

			self.inputVM.currentSearchVM.text = suggest.text;
			[self setSearchResultForCurrentSearchVM:suggest];
			[self switchToNextTextFiledIfNeeded];
			[self startSearchIfNeeded];
		}];
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
	@weakify(self);

	if (self.inputVM.fromSearchVM.dbObject && self.inputVM.toSearchVM.dbObject)
	{
		[[self fetchTaxiList]
			subscribeNext:^(id _) {
				@strongify(self);
				
				[self.inputVM.fromSearchVM clearSuggestsAndResults];
				[self.inputVM.toSearchVM clearSuggestsAndResults];
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

	return [[[TKSDataProvider sharedProvider] fetchTaxiListFromObject:self.inputVM.fromSearchVM.dbObject
															 toObject:self.inputVM.toSearchVM.dbObject]
		doNext:^(NSArray<TKSTaxiSection *> *taxiList) {
			@strongify(self);

			self.taxiListVM.data = taxiList;
		}];
}

@end
