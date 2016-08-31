#import "DGSMailSender.h"

NSString *const kDGSAttachmentDataKey = @"AttachmentDataKey";
NSString *const kDGSAttachmentFileNameKey = @"AttachmentFileNameKey";
NSString *const kDGSAttachmentMimeKey = @"AttachmentMimeKey";

@interface DGSMailSender() <MFMailComposeViewControllerDelegate>
@end

@implementation DGSMailSender

// MARK: Lifecycle

+ (instancetype)sharedInstance
{
	static DGSMailSender *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[DGSMailSender alloc] init];
	});
	return instance;
}

// MARK: Class methods

+ (void)sendMailTo:(NSArray *)recipients
		   subject:(NSString *)subject
	   messageBody:(NSString *)messageBody
		isBodyHtml:(BOOL)isBodyHtml
	   attachments:(NSArray *)attachments
	rootController:(UIViewController *)controller
 completionHandler:(dispatch_block_t)handler
{
	DGSMailSender *sender = [DGSMailSender sharedInstance];
	[sender sendMailTo:recipients
			   subject:subject
		   messageBody:messageBody
			isBodyHtml:isBodyHtml
		   attachments:attachments
	withRootController:controller
	 completionHandler:handler];
}

+ (BOOL)canSendMail
{
	return [MFMailComposeViewController canSendMail];
}

+ (void)showNoMailAlert
{
	NSString *message = @"Ваше устройство не настроено для отправки e-mail.\nПроверьте настройки учётных записей.";
	[[RACScheduler mainThreadScheduler] schedule:^{
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка отправки e-mail"
																	   message:message
																preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть"
															   style:UIAlertActionStyleDestructive
															 handler:nil];
		[alert addAction:cancelAction];

		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
	}];
}

// MARK: Private

- (void)sendMailTo:(NSArray *)recipients
		   subject:(NSString *)subject
	   messageBody:(NSString *)messageBody
		isBodyHtml:(BOOL)isBodyHtml
	   attachments:(NSArray *)attachments
withRootController:(UIViewController *)controller
 completionHandler:(dispatch_block_t)handler
{
	dispatch_block_t cachedHandler = [handler copy];
	if ([DGSMailSender canSendMail])
	{
		[[RACScheduler mainThreadScheduler] schedule:^{
			// NOTE: Всё это безумие с цветами до и после создания композера на самом деле не безумие,
			// а единственный рабочий способ сделать то, что хочется по дизайну. Было обнаружено в ходе
			// ручного перебора всех возможных вариантов.
			UINavigationBar.appearance.translucent = NO;
//			UINavigationBar.appearance.barTintColor = [UIColor dgs_outerSpaceColor];
			MFMailComposeViewController *mailPickerVC = [[MFMailComposeViewController alloc] init];
//			[mailPickerVC.navigationBar setTintColor:[UIColor dgs_keyLimePieColor]];

			mailPickerVC.mailComposeDelegate = self;
			[mailPickerVC setToRecipients:recipients];
			[mailPickerVC setSubject:subject];
			[mailPickerVC setMessageBody:messageBody isHTML:isBodyHtml];

			for (id attachment in attachments)
			{
				NSData *data = attachment[kDGSAttachmentDataKey];
				NSString *mimeType = attachment[kDGSAttachmentMimeKey];
				NSString *fileName = attachment[kDGSAttachmentFileNameKey];
				[mailPickerVC addAttachmentData:data mimeType:mimeType fileName:fileName];
			}

			[controller presentViewController:mailPickerVC
									 animated:YES
								   completion:cachedHandler];
		}];
	}
}

// MARK: MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error
{
	[controller dismissViewControllerAnimated:YES completion:nil];
}

@end
