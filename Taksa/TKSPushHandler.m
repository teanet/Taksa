#import "TKSPushHandler.h"

@interface TKSPushHandler ()

@property (nonatomic, copy) NSDictionary *pushInfo;

@end

@implementation TKSPushHandler

+ (instancetype)sharedHandler {
	static id manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[[self class] alloc] init];
	});
	return manager;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	[self processPushInfo:userInfo];

	if (completionHandler)
	{
		completionHandler(UIBackgroundFetchResultNoData);
	}
}

- (void)processPushInfo:(NSDictionary *)pushInfo
{
	NSString *action = pushInfo[@"action"];

	BOOL showAlert = [action isEqualToString:@"alert"] ||
					 ([action isEqualToString:@"silent_alert"] &&
					  [UIApplication sharedApplication].applicationState != UIApplicationStateActive);

	if (showAlert)
	{
		NSString *message = pushInfo[@"message"];
		NSString *title = pushInfo[@"title"];

		UIAlertController *alert = [self alertControllerWithTitle:title
														  message:message];
		[self presentAlert:alert];
	}
}

- (UIAlertController *)alertControllerWithTitle:(NSString *)title
										message:(NSString *)message
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
																   message:message
															preferredStyle:UIAlertControllerStyleAlert];


	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ОК"
														   style:UIAlertActionStyleDestructive
														 handler:nil];

	[alert addAction:cancelAction];

	return alert;
}

- (void)presentAlert:(UIAlertController *)alert
{
	[[RACScheduler mainThreadScheduler]
		schedule:^{
			[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
		}];
}

@end
