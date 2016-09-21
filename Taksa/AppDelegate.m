#import "AppDelegate.h"

#import "TKSRootVC.h"
#import "TKSDataProvider.h"
#import "TKSPushHandler.h"
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
	[self registerForRemoteNotification];

	return YES;
}

- (void)configureWindow
{
	TKSRootVC *rootVC = [[TKSRootVC alloc] initWithVM:[[TKSRootVM alloc] init]];

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = rootVC;
	[self.window makeKeyAndVisible];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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

// Push Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);

	[[TKSDataProvider sharedProvider] setPushToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	NSLog(@"Did Receive: %@", userInfo);
	[[TKSPushHandler sharedHandler] application:nil didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	NSLog(@"didReceiveRemoteNotification >>> %@", userInfo);
	[[TKSPushHandler sharedHandler] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)registerForRemoteNotification
{
	[[UIApplication sharedApplication] registerUserNotificationSettings:
		[UIUserNotificationSettings settingsForTypes:( UIUserNotificationTypeSound |
													  UIUserNotificationTypeAlert |
													  UIUserNotificationTypeBadge) categories:nil]];

	[[UIApplication sharedApplication] registerForRemoteNotifications];
}

@end
