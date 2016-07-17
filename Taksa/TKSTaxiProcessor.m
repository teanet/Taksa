#import "TKSTaxiProcessor.h"

#import "TKSTaxiRow.h"
#import "TKSSuggest.h"

@implementation TKSTaxiProcessor

- (void)processTaxiRow:(TKSTaxiRow *)taxiRow
		   fromSuggest:(TKSSuggest *)fromSuggest
			 toSuggest:(TKSSuggest *)toSugges
{
	if (taxiRow.phoneValue.length > 1)
	{
		[self callTaxi:taxiRow];
	}
	else if (taxiRow.siteUrlString.length > 0)
	{
		NSURL *url = [NSURL URLWithString:taxiRow.siteUrlString];
		[self openTaxiURL:taxiRow url:url];
	}
}

- (void)callTaxi:(TKSTaxiRow *)taxiRow
{
	NSString *message = [NSString stringWithFormat:@"Позвонить в такси %@?", taxiRow.title];

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

- (void)openTaxiURL:(TKSTaxiRow *)taxiRow
				url:(NSURL *)url
{
	NSString *message = [NSString stringWithFormat:@"Открыть сайт такси %@?", taxiRow.title];

	UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"Открыть сайт"
														 style:UIAlertActionStyleDefault
													   handler:^(UIAlertAction * _Nonnull action) {
	   [[RACScheduler mainThreadScheduler]
			schedule:^{
				[[UIApplication sharedApplication] openURL:url];
			}];
   }];

	UIAlertController *alert = [self alertControllerWithTitle:@"Открыть сайт" message:message action:callAction];
	
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
