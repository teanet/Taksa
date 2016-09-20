#import "TKSSelectCityVC.h"

@interface TKSSelectCityVC ()

@property (nonatomic, strong, readonly) UITableView *tableView;

@end

@implementation TKSSelectCityVC

- (instancetype)initWithVM:(id)orderVM
{
	self = [super initWithVM:orderVM];
	if (self == nil) return nil;

	self.title = @"Выберите город";

	return self;
}

- (void)loadView
{
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.view = [[UIView alloc] init];
}

- (void)dealloc
{
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
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
