#import "AppDelegate.h"
#import "TKSRootVC.h"

#import "UIColor+DGSCustomColor.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self configureWindow];
	return YES;
}

- (void)configureWindow
{
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
	[[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

	TKSRootVC *rootVC = [[TKSRootVC alloc] initWithVM:[[TKSRootVM alloc] init]];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
	navigationController.navigationBar.translucent = NO;
	[navigationController.navigationBar setBarStyle:UIBarStyleBlack];
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = navigationController;
	[self.window makeKeyAndVisible];
}

@end
