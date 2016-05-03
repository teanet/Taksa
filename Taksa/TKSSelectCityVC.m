#import "TKSSelectCityVC.h"

@interface TKSSelectCityVC ()

@property (nonatomic, strong, readonly) UITableView *tableView;

@end

@implementation TKSSelectCityVC

- (void)loadView
{
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.view = [[UIView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	@weakify(self);

	[self setEdgesForExtendedLayout:UIRectEdgeNone];
	[self.view addSubview:self.tableView];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];

	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self.viewModel action:@selector(close)];
	[self.viewModel registerTableView:self.tableView];
	
	[RACObserve(self.viewModel, regions)
		subscribeNext:^(id _) {
			@strongify(self);

			[self.tableView reloadData];
		}];
}

@end
