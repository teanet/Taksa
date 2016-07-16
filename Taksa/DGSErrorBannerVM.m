#import "DGSErrorBannerVM.h"

@interface DGSErrorBannerAction ()

@property (nonatomic, copy, readonly) dispatch_block_t actionHandler;

@end

@implementation DGSErrorBannerAction

- (instancetype)initWithImage:(UIImage *)image
				actionHandler:(dispatch_block_t)actionHandler
{
	self = [super init];
	if (!self) return nil;

	_actionHandler = [actionHandler copy];
	_image = image;

	return self;
}

- (void)performAction
{
	if (self.actionHandler)
	{
		self.actionHandler();
	}
}

@end

@interface DGSErrorBannerVM ()

@property (nonatomic, strong, readwrite) DGSErrorBannerModel *model;

@end

@implementation DGSErrorBannerVM

- (instancetype)initWithAutohideMode:(DGSErrorBannerAutohideMode)autohideMode
{
	self = [super init];
	if (!self) return nil;

	_autohideMode = autohideMode;

	return self;
}

- (instancetype)init
{
	return [self initWithAutohideMode:DGSErrorBannerAutohideModeByTouch];
}

- (NSArray<DGSErrorBannerAction *> *)actions
{
	return self.model.actions;
}

- (NSAttributedString *)attributedMessage
{
	NSString *messageString = (self.model.errorDescription.length > 0)
		? [NSString stringWithFormat:@"%@\n%@", self.model.errorTitle, self.model.errorDescription]
		: self.model.errorTitle;

	NSMutableAttributedString *messageAttributedText = [[NSMutableAttributedString alloc] initWithString:messageString];
	[messageAttributedText addAttribute:NSFontAttributeName
								  value:[UIFont systemFontOfSize:15.0]
								  range:NSMakeRange(0, self.model.errorTitle.length)];
	if (self.model.errorDescription.length > 0)
	{
		[messageAttributedText addAttribute:NSFontAttributeName
									  value:[UIFont systemFontOfSize:11.5]
									  range:NSMakeRange(self.model.errorTitle.length + 1,
														self.model.errorDescription.length)];
	}

	return [messageAttributedText copy];
}

- (UIImage *)imageFront
{
	return self.model.image;
}

- (UIImage *)imageBack
{
	return self.model.secondaryImage;
}

- (void)showMessage:(NSString *)message
{
	self.model = message.length > 0
		? [[DGSErrorBannerModel alloc] initWithErrorTitle:message image:nil secondaryImage:nil]
		: nil;
}

- (void)showWithModel:(DGSErrorBannerModel *)model
{
	self.model = model;
}

- (void)hide
{
	self.model = nil;
}

- (void)performActionWithIndex:(NSUInteger)index
{
	if (index >= self.actions.count) return;

	DGSErrorBannerAction *action = self.actions[index];
	[action performAction];
	if (self.autohideMode == DGSErrorBannerAutohideModeByButtonTap)
	{
		[self hide];
	}
}

@end
