#import "TKSRootVC.h"

#import "TKSHomeVC.h"

#import "DGSErrorBannerView.h"
#import "UIViewController+DGSAdditions.h"


@interface TKSRootVC ()

@property (nonatomic, strong, readonly) TKSHomeVC *homeVC;
@property (nonatomic, strong, readonly) DGSErrorBannerView *errorBannerView;

@end

@implementation TKSRootVC

- (instancetype)initWithVM:(id)orderVM
{
	self = [super initWithVM:orderVM];
	if (self == nil) return nil;

	_homeVC = [[TKSHomeVC alloc] initWithVM:[[TKSHomeVM alloc] init]];

	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	_errorBannerView = [[DGSErrorBannerView alloc] initWithViewModel:self.viewModel.errorBannerVM];

	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
	navigationController.navigationBar.translucent = NO;
	[navigationController.navigationBar setBarStyle:UIBarStyleBlack];
	[self dgs_showViewController:navigationController inView:self.view];
}


@end
