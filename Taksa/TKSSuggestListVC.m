#import "TKSSuggestListVC.h"

@interface TKSSuggestListVC ()

@property (nonatomic, strong, readonly) UITableView *tableView;

@end

@implementation TKSSuggestListVC

- (void)loadView
{
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_tableView.tableFooterView = [[UIView alloc] init];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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

	[self.view addSubview:_tableView];

	[self.viewModel registerTableView:_tableView];

	[_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}

@end
