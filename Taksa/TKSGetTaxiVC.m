#import "TKSGetTaxiVC.h"

@interface TKSGetTaxiVC ()

@property (nonatomic, strong, readonly) UITableView *tableView;

@end

@implementation TKSGetTaxiVC

- (void)dealloc
{
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_tableView.tableFooterView = [[UIView alloc] init];
	[self.view addSubview:_tableView];

	[self.viewModel registerTableView:_tableView];
}

@end
