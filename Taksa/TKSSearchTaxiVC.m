#import "TKSSearchTaxiVC.h"

#import "UIColor+DGSCustomColor.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

@interface TKSSearchTaxiVC ()

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) DGActivityIndicatorView *spinner;
@property (nonatomic, strong, readonly) UIImageView *carImageView;
@property (nonatomic, assign) CGFloat carsBottomOffset;

@end

@implementation TKSSearchTaxiVC

- (void)dealloc
{
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor dgs_colorWithString:@"F4F4F4"];

	_carImageView = [[UIImageView alloc] init];
	_carImageView.contentMode = UIViewContentModeCenter;
	_carImageView.image = [UIImage imageNamed:@"cars"];

	_spinner = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator
												   tintColor:[UIColor dgs_colorWithString:@"FFE400"]
														size:50.0];

	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_tableView.tableFooterView = [[UIView alloc] init];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.showsVerticalScrollIndicator = NO;
	_tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 16.0, 0.0);
	[self.view addSubview:_tableView];

	UIView *statusBarView = [[UIView alloc] init];
	statusBarView.backgroundColor = [UIColor dgs_colorWithString:@"F4F4F4"];
	[self.view addSubview:statusBarView];

	[statusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view);
		make.leading.equalTo(self.view);
		make.trailing.equalTo(self.view);
		make.height.equalTo(@20.0);
	}];

	[_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0));
	}];

	[self.viewModel registerTableView:_tableView];
}

@end
