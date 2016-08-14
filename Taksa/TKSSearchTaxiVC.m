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
	[self.view addSubview:_tableView];

	[_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];

	[self.viewModel registerTableView:_tableView];
}

@end
