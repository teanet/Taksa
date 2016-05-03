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
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[TKSRootVC alloc] init]];
	navigationController.navigationBar.translucent = NO;
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = navigationController;
	[self.window makeKeyAndVisible];
}

@end
