#import "TKSOrderVM.h"

#import "TKSTaxiListVM.h"
#import "TKSTaxiSection.h"
#import "TKSDataProvider.h"

@interface TKSOrderVM ()

@property (nonatomic, strong, readonly) TKSTaxiListVM *taxiListVM;
@property (nonatomic, strong) TKSDatabaseObject *objectFrom;
@property (nonatomic, strong) TKSDatabaseObject *objectTo;

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
		self.objectFrom = nil;
	}
	else
	{
		self.objectTo = nil;
	}
}

- (void)setSearchResultForCurrentSearchVM:(TKSDatabaseObject *)dbObject
{
	if (self.inputVM.currentSearchVM == self.inputVM.fromSearchVM)
	{
		self.objectFrom = dbObject;
	}
	else
	{
		self.objectTo = dbObject;
	}
}

- (void)toggleTextField
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
		if (self.inputVM.fromSearchVM.text.length > 0)
		{
			// Ищем
			
		}
		else
		{
			self.inputVM.fromSearchVM.active = YES;
			self.inputVM.toSearchVM.active = NO;
		}
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

- (void)loadDataWithCompletion:(dispatch_block_t)block
{
	@weakify(self);
	[[[RACSignal return:nil]
		delay:1.0]
		subscribeNext:^(id _) {
			@strongify(self);

			self.taxiListVM.data = @[
				[TKSTaxiSection testGroupeSuggest],
				[TKSTaxiSection testGroupeList],
			];

			block();
		}];
}

- (RACSignal *)searchTaxiSignal
{
	@weakify(self);

	RACSignal *objectFromSignal = self.objectFrom
		? [RACSignal return:self.objectFrom]
		: [[[TKSDataProvider sharedProvider] fetchObjectsForSearchString:self.inputVM.fromSearchVM.text]
			map:^TKSDatabaseObject *(NSArray<TKSDatabaseObject *> *dbObjects) {
				return dbObjects.firstObject;
			}];

	RACSignal *objectToSignal = self.objectTo
		? [RACSignal return:self.objectFrom]
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
