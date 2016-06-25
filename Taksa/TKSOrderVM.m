#import "TKSOrderVM.h"

#import "TKSTaxiListVM.h"
#import "TKSTaxiSection.h"
#import "TKSDataProvider.h"

@interface TKSOrderVM ()

@property (nonatomic, strong, readonly) TKSTaxiListVM *taxiListVM;

@end

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
		subscribeNext:^(TKSSuggest *suggest) {
			@strongify(self);

			self.inputVM.currentSearchVM.text = suggest.text;
			[self clearSearchResultForCurrentSearchVM];
		}];

	[self.suggestListModel.didSelectResultSignal
		subscribeNext:^(TKSDatabaseObject *dbObject) {
			@strongify(self);

			self.inputVM.currentSearchVM.text = dbObject.fullName;
			[self setSearchResultForCurrentSearchVM:dbObject];
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

- (void)setSearchResultForCurrentSearchVM:(TKSDatabaseObject *)dbObject
{
	if (self.inputVM.currentSearchVM == self.inputVM.fromSearchVM)
	{
		self.inputVM.fromSearchVM.dbObject = dbObject;
	}
	else
	{
		self.inputVM.toSearchVM.dbObject = dbObject;
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

	RACSignal *objectFromSignal = self.inputVM.fromSearchVM.dbObject
		? [RACSignal return:self.inputVM.fromSearchVM.dbObject]
		: [[[TKSDataProvider sharedProvider] fetchObjectsForSearchString:self.inputVM.fromSearchVM.text]
			map:^TKSDatabaseObject *(NSArray<TKSDatabaseObject *> *dbObjects) {
				return dbObjects.firstObject;
			}];

	RACSignal *objectToSignal = self.inputVM.toSearchVM.dbObject
		? [RACSignal return:self.inputVM.toSearchVM.dbObject]
		: [[[TKSDataProvider sharedProvider] fetchObjectsForSearchString:self.inputVM.toSearchVM.text]
		   map:^TKSDatabaseObject *(NSArray<TKSDatabaseObject *> *dbObjects) {
			   return dbObjects.firstObject;
		   }];

	return [[[objectFromSignal combineLatestWith:objectToSignal]
		flattenMap:^RACStream *(RACTuple *t) {
			RACTupleUnpack(TKSDatabaseObject *objectFrom, TKSDatabaseObject *objectTo) = t;

			return [[TKSDataProvider sharedProvider] fetchTaxiListFromObject:objectFrom toObject:objectTo];
		}]
		doNext:^(NSArray<TKSTaxiSection *> *taxiList) {
			@strongify(self);

			self.taxiListVM.data = taxiList;
		}];
}

@end
