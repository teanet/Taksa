#import "TKSTaxiProcessor.h"

#import "TKSTaxiRow.h"
#import "TKSSuggest.h"

@implementation TKSTaxiProcessor

- (void)processTaxiRow:(TKSTaxiRow *)taxiRow
{
	if (taxiRow.phoneValue.length > 1)
	{
		[self callTaxi:taxiRow];
	}
	else if (taxiRow.siteUrlString.length > 0)
	{
		NSURL *appURL = [NSURL URLWithString:taxiRow.appUrlString];

		BOOL canOpenAppURL =
			appURL.absoluteString.length > 0 &&
			[[UIApplication sharedApplication] canOpenURL:appURL];

		NSURL *url = canOpenAppURL
			? appURL
			: [NSURL URLWithString:taxiRow.siteUrlString];

		[self openTaxiURL:taxiRow url:url application:canOpenAppURL];
	}
}

- (void)callTaxi:(TKSTaxiRow *)taxiRow
{
	NSString *message = [NSString stringWithFormat:@"Позвонить в %@?", taxiRow.shortTitle];

	UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"Позвонить"
														 style:UIAlertActionStyleDefault
													   handler:^(UIAlertAction * _Nonnull action) {
		[[RACScheduler mainThreadScheduler]
			schedule:^{
				NSLog(@"Will call number: %@", taxiRow.phoneValue);
				NSString *number = [NSString stringWithFormat:@"tel://%@", taxiRow.phoneValue];
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
			}];
	}];

	UIAlertController *alert = [self alertControllerWithTitle:@"Позвонить" message:message action:callAction];

	[self presentAlert:alert];
}

- (void)openTaxiURL:(TKSTaxiRow *)taxiRow url:(NSURL *)url application:(BOOL)application
{
	NSString *message = application
		? [NSString stringWithFormat:@"Перейти в приложение %@?", taxiRow.shortTitle]
		: [NSString stringWithFormat:@"Перейти на сайт %@?", taxiRow.shortTitle];

	NSString *buttonTitle = application ? @"Перейти" : @"Открыть сайт";
	UIAlertAction *callAction = [UIAlertAction actionWithTitle:buttonTitle
														 style:UIAlertActionStyleDefault
													   handler:^(UIAlertAction * _Nonnull action) {
	   [[RACScheduler mainThreadScheduler]
			schedule:^{
				[[UIApplication sharedApplication] openURL:url];
			}];
   }];

	NSString *alertTitle = application ? @"Перейти в приложение" : @"Перейти на сайт";
	UIAlertController *alert = [self alertControllerWithTitle:alertTitle message:message action:callAction];
	
	[self presentAlert:alert];
}

- (void)presentAlert:(UIAlertController *)alert
{
	[[RACScheduler mainThreadScheduler]
		schedule:^{
			[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
		}];
}

- (UIAlertController *)alertControllerWithTitle:(NSString *)title
										message:(NSString *)message
										 action:(UIAlertAction *)action
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
																   message:message
															preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть"
														   style:UIAlertActionStyleDestructive
														 handler:nil];
	
	[alert addAction:action];
	[alert addAction:cancelAction];

	return alert;
}

@end
