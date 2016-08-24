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

#import "DGSMailSender.h"
#import "UIWindow+SIUtils.h"

@interface TKSSearchTaxiVM () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;
@property (nonatomic, strong, readonly) TKSTaxiResults *taxiResults;
@property (nonatomic, copy, readonly) NSArray<id<TKSTableSectionVMProtocol>> *sectionVMs;
@property (nonatomic, strong, readonly) RACSignal *shouldReloadTableSignal;
@property (nonatomic, assign, readwrite) TKSSearchTaxiMode mode;

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
	[self setupReactiveStuff];

	return self;
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[[[[RACObserve(self.taxiResults, taxiSections)
		ignore:nil]
		skip:1]
		filter:^BOOL(NSArray *results) {
			return results.count == 0;
		}]
		subscribeNext:^(id _) {
			@strongify(self);

			self.mode = TKSSearchTaxiModeError;
		}];
}

- (void)createSections
{
	@weakify(self);

	TKSInputSectionVM *inputSectionVM = [[TKSInputSectionVM alloc] initWithModel:self.inputVM];
	TKSResultsSectionVM *resultsSectionVM = [[TKSResultsSectionVM alloc] initWithModel:self.taxiResults];

	RACSignal *manualReloadTableSignal = [self rac_signalForSelector:@checkselector0(self, reloadTable)];

	[[inputSectionVM.shouldSearchTaxiSignal
		deliverOnMainThread]
		subscribeNext:^(RACTuple *tuple) {
			@strongify(self);

			[self hideKeyboard];
			self.mode = TKSSearchTaxiModeSearching;
			[self.taxiResults fetchTaxiResultsFromSuggest:tuple.first toSuggest:tuple.second];
			[self reloadTable];
		}];

	_sectionVMs = @[
		inputSectionVM,
		resultsSectionVM,
	];

	NSArray<RACSignal *> *shouldReloadTableSignals = [_sectionVMs.rac_sequence
		map:^RACSignal *(TKSTableSectionVM *sectionVM) {
			return sectionVM.shouldReloadTableSignal;
		}].array;

	_shouldReloadTableSignal = [[RACSignal merge:shouldReloadTableSignals] merge:manualReloadTableSignal];
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
			else if ([section isKindOfClass:[TKSResultsSectionVM class]])
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
	if (!self.shouldHideKeyboardOnScroll) return;

	[self hideKeyboard];
}

- (void)hideKeyboard
{
	[[RACScheduler mainThreadScheduler]
		schedule:^{
			self.inputVM.fromSearchVM.active = NO;
			self.inputVM.toSearchVM.active = NO;
		}];
}

- (void)reportError
{
	UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.currentViewController;

	if ([DGSMailSender canSendMail])
	{
		NSString *contactEmail = @"taxi@2gis.ru";

		[DGSMailSender sendMailTo:@[contactEmail]
						  subject:@"Разработчикам Таксы"
					  messageBody:@""
					   isBodyHtml:NO
					  attachments:nil
				   rootController:topViewController
				completionHandler:nil];
	}
	else
	{
		[DGSMailSender showNoMailAlert];
	}
}

- (void)reloadTable
{
}

@end
