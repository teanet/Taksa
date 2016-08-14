#import "TKSSearchTaxiVM.h"

#import "TKSSuggestCell.h"
#import "TKSInputHeaderView.h"
#import "TKSInputSectionVM.h"
#import "TKSTaxiSuggestCell.h"
#import "TKSTaxiDefaultCell.h"
#import "TKSTaxiHeaderCell.h"
#import "TKSResultsSectionVM.h"

#import "TKSDataProvider.h"
#import "TKSTaxiResults.h"

typedef NS_ENUM (NSInteger, TKSSearchTaxiMode) {
	TKSSearchTaxiModeSuggest,
	TKSSearchTaxiModeSearching,
	TKSSearchTaxiModeResults
};

@interface TKSSearchTaxiVM () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;
@property (nonatomic, strong, readonly) TKSTaxiResults *taxiResults;
@property (nonatomic, copy, readonly) NSArray<id<TKSTableSectionVMProtocol>> *sectionVMs;
@property (nonatomic, strong, readonly) RACSignal *shouldReloadTableSignal;
@property (nonatomic, assign) TKSSearchTaxiMode mode;

@end

@implementation TKSSearchTaxiVM

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM
{
	self = [super init];
	if (self == nil) return nil;

	_inputVM = inputVM ?: [[TKSInputVM alloc] init];
	_taxiResults = [[TKSTaxiResults alloc] init];
	_mode = TKSSearchTaxiModeSuggest;

	[self createSections];

	return self;
}

- (void)createSections
{
	@weakify(self);

	TKSInputSectionVM *inputSectionVM = [[TKSInputSectionVM alloc] initWithModel:self.inputVM];
	TKSResultsSectionVM *resultsSectionVM = [[TKSResultsSectionVM alloc] initWithModel:self.taxiResults];

	[inputSectionVM.shouldSearchTaxiSignal
		subscribeNext:^(RACTuple *tuple) {
			@strongify(self);

			[self.taxiResults fetchTaxiResultsFromSuggest:tuple.first toSuggest:tuple.second];
		}];

	_sectionVMs = @[
		inputSectionVM,
		resultsSectionVM,
	];

	NSArray<RACSignal *> *shouldReloadTableSignals = [_sectionVMs.rac_sequence
		map:^RACSignal *(TKSTableSectionVM *sectionVM) {
			return sectionVM.shouldReloadTableSignal;
		}].array;

	_shouldReloadTableSignal = [RACSignal merge:shouldReloadTableSignals];
}

- (void)registerTableView:(UITableView *)tableView
{
	@weakify(self);

	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.estimatedRowHeight = 200.0;
	tableView.estimatedSectionHeaderHeight = 120.0;

	[tableView registerClass:[TKSInputHeaderView class]
		forHeaderFooterViewReuseIdentifier:NSStringFromClass([TKSInputSectionVM class])];
	[tableView registerClass:[TKSSuggestCell class]
		forCellReuseIdentifier:NSStringFromClass([TKSSuggestCellVM class])];
	[tableView registerClass:[TKSTaxiSuggestCell class]
		forCellReuseIdentifier:NSStringFromClass([TKSTaxiSuggestCellVM class])];
	[tableView registerClass:[TKSTaxiDefaultCell class]
		forCellReuseIdentifier:NSStringFromClass([TKSTaxiDefaultCellVM class])];
	[tableView registerClass:[TKSTaxiHeaderCell class]
		forCellReuseIdentifier:NSStringFromClass([TKSTaxiHeaderCellVM class])];

	[[self.shouldReloadTableSignal
		deliverOnMainThread]
		subscribeNext:^(TKSTableSectionVM *section) {
			@strongify(self);

			if ([section isKindOfClass:[TKSInputSectionVM class]])
			{
				self.mode = TKSSearchTaxiModeSuggest;
			}
			else
			{
				self.mode = TKSSearchTaxiModeResults;
			}

			// Clear all other sections
			[self.sectionVMs enumerateObjectsUsingBlock:^(id<TKSTableSectionVMProtocol> s, NSUInteger _, BOOL *__) {
				if (![section isEqual:s])
				{
					[s clearSection];
				}
			}];

			[tableView reloadData];
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
	return section == 0 ? UITableViewAutomaticDimension : 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	id<TKSTableSectionVMProtocol> section = [self.sectionVMs objectAtIndex:indexPath.section];
	[section didSelectCellVMAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[[RACScheduler mainThreadScheduler]
		schedule:^{
			self.inputVM.fromSearchVM.active = NO;
			self.inputVM.toSearchVM.active = NO;
		}];
}

@end
