#import "AppDelegate.h"
#import "TKSRootVC.h"

#import "UIColor+DGSCustomColor.h"
#import <SSKeychain.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[SSKeychain setAccessibilityType:kSecAttrAccessibleAlwaysThisDeviceOnly];

	[self configureAppearance];
	[self configureWindow];
	return YES;
}

- (void)configureWindow
{
	TKSRootVC *rootVC = [[TKSRootVC alloc] initWithVM:[[TKSRootVM alloc] init]];

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = rootVC;
	[self.window makeKeyAndVisible];
}

- (void)configureAppearance
{
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
	[[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
}

@end
