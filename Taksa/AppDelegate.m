#import "AppDelegate.h"
#import "TKSRootVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self configureWindow];
	return YES;
}

- (void)configureWindow
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[TKSRootVC alloc] init]];
	[self.window makeKeyAndVisible];

}

@end
