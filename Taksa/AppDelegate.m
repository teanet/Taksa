#import "AppDelegate.h"

#import "TKSRootVC.h"
#import "DGSUIKitMainThreadGuard.h"

#import <SSKeychain/SSKeychain.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[Fabric with:@[CrashlyticsKit]];

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

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	DGSSetupUIKitMainThreadGuard();

	return YES;
}

- (void)configureAppearance
{
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
	[[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
}

@end
