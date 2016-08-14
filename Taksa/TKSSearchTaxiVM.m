#import "TKSSearchTaxiVM.h"

#import "TKSSuggestCell.h"
#import "TKSInputHeaderView.h"
#import "TKSInputSectionVM.h"

#import "TKSDataProvider.h"

@interface TKSSearchTaxiVM () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;
@property (nonatomic, copy, readonly) NSArray<id<TKSTableSectionVMProtocol>> *sectionVMs;
@property (nonatomic, strong, readonly) RACSignal *shouldReloadTableSignal;
@property (nonatomic, assign) BOOL tableScrollEnabled;

@end

@implementation TKSSearchTaxiVM

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM
{
	self = [super init];
	if (self == nil) return nil;

	_inputVM = inputVM ?: [[TKSInputVM alloc] init];
	_tableScrollEnabled = YES;

	[self createSections];

	return self;
}

- (void)createSections
{
	@weakify(self);

	TKSInputSectionVM *inputSectionVM = [[TKSInputSectionVM alloc] initWithModel:self.inputVM];

	[inputSectionVM.shouldSearchTaxiSignal
		subscribeNext:^(RACTuple *tuple) {
			@strongify(self);

			[self fetchTaxiFromSuggest:tuple.first toSuggest:tuple.second];
		}];

	_sectionVMs = @[
		inputSectionVM,
	];

	NSArray<RACSignal *> *shouldReloadTableSignals = [_sectionVMs.rac_sequence
		map:^RACSignal *(TKSTableSectionVM *sectionVM) {
			return sectionVM.shouldReloadTableSignal;
		}].array;

	_shouldReloadTableSignal = [RACSignal merge:shouldReloadTableSignals];
}

- (void)registerTableView:(UITableView *)tableView
{
	tableView.delegate = self;
	tableView.dataSource = self;

	[tableView registerClass:[TKSInputHeaderView class]
		forHeaderFooterViewReuseIdentifier:NSStringFromClass([TKSInputSectionVM class])];
	[tableView registerClass:[TKSSuggestCell class]
		forCellReuseIdentifier:NSStringFromClass([TKSSuggestCellVM class])];

	[[[RACObserve(self, tableScrollEnabled)
		ignore:nil]
		deliverOnMainThread]
		subscribeNext:^(NSNumber *scrollEnabled) {
			tableView.scrollEnabled = scrollEnabled.boolValue;
		}];

	[[self.shouldReloadTableSignal
		deliverOnMainThread]
		subscribeNext:^(id _) {
			[tableView reloadData];
		}];
}

- (void)fetchTaxiFromSuggest:(TKSSuggest *)fromSuggest toSuggest:(TKSSuggest *)toSuggest
{
	[[[[TKSDataProvider sharedProvider] fetchTaxiListFromObject:fromSuggest toObject:toSuggest]
		delay:1.0]
		subscribeNext:^(NSArray<TKSTaxiSection *> *taxiList) {
			NSLog(@">>> %@", taxiList);
		}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.sectionVMs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id<TKSTableSectionVMProtocol> sectionVM = [self.sectionVMs objectAtIndex:section];
	return sectionVM.cellVMs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TKSTableViewCell *cell = nil;

	id<TKSTableSectionVMProtocol> sectionVM = [self.sectionVMs objectAtIndex:indexPath.section];
	TKSBaseVM *cellVM = [sectionVM.cellVMs objectAtIndex:indexPath.row];

	cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([cellVM class])];
	cell.viewModel = cellVM;

	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	id<TKSTableSectionVMProtocol> sectionVM = [self.sectionVMs objectAtIndex:section];

	TKSTableViewHeaderFooterView *headerView =
		[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([sectionVM class])];

	headerView.viewModel = sectionVM;

	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 136.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	id<TKSTableSectionVMProtocol> section = [self.sectionVMs objectAtIndex:indexPath.section];
	if ([section isKindOfClass:[TKSInputSectionVM class]])
	{
		TKSInputSectionVM *sectionMapVM = (TKSInputSectionVM *)section;
		[sectionMapVM didSelectCellVMAtIndexPath:indexPath];
	}
}

@end
