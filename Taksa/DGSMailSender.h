#import <MessageUI/MessageUI.h>

extern NSString *const kDGSAttachmentDataKey;
extern NSString *const kDGSAttachmentFileNameKey;
extern NSString *const kDGSAttachmentMimeKey;

@interface DGSMailSender : NSObject

/*! Send mail
 *
 *  \param recipients list of NSString objects of emails
 *  \param subject mail subject
 *  \param messageBody initial content of the message
 *  \param isBodyHtml whether given body is in HTML format
 *  \param attachments array of dictionaries with format: @{
 *															kDGSAttachmentFileNameKey: NSData *
 *															kDGSAttachmentMimeKey: NSString *
 *															kDGSAttachmentDataKey: NSString *
 *															}
 *  \param controller the root controller to present mail controller modally
 *  \param completionHandler will be called after sending/canceling mail composer.
 **/
+ (void)sendMailTo:(NSArray *)recipients
		   subject:(NSString *)subject
	   messageBody:(NSString *)messageBody
		isBodyHtml:(BOOL)isBodyHtml
	   attachments:(NSArray *)attachments
	rootController:(UIViewController *)controller
 completionHandler:(dispatch_block_t)handler;

/*! Check if we can send emails */
+ (BOOL)canSendMail;

/*! Show has no mail alert dialog */
+ (void)showNoMailAlert;

@end
