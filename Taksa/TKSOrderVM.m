#import "TKSOrderVM.h"

#import "TKSTaxiSection.h"
#import "TKSDataProvider.h"

@implementation TKSOrderVM

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM
{
	self = [super init];
	if (self == nil) return nil;

	_taxiListVM = [[TKSTaxiListVM alloc] init];
	_suggestListModel = [[TKSSuggestListModel alloc] init];
	_inputVM = inputVM ?: [[TKSInputVM alloc] init];

	[self setupReactiveStuff];

	return self;
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[self.suggestListModel.didSelectSuggestSignal
		subscribeNext:^(TKSSuggestObject *suggest) {
			@strongify(self);

			self.inputVM.currentSearchVM.text = suggest.text;
			[self setSearchResultForCurrentSearchVM:suggest];
			[self toggleTextField];
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

- (void)setSearchResultForCurrentSearchVM:(TKSSuggestObject *)suggest
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

- (void)toggleTextField
{
	[self switchToNextTextFiledIfNeeded];
	[self startSearchIfNeeded];
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
	[self.suggestListModel registerTableView:tableView];
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
