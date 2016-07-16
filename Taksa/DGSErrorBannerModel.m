#import "DGSErrorBannerModel.h"

@implementation DGSErrorBannerModel

- (instancetype)initWithErrorTitle:(NSString *)errorTitle
				  errorDescription:(NSString *_Nullable)errorDescription
							 image:(UIImage *_Nullable)image
					secondaryImage:(UIImage *_Nullable)secondaryImage
						   actions:(NSArray<DGSErrorBannerAction *> *_Nullable)actions
{
	self = [super init];
	if (!self) return nil;

	_errorTitle = [errorTitle copy];
	_errorDescription = errorDescription.length > 0 ? [errorDescription copy] : @"";
	_image = image;
	_secondaryImage = secondaryImage;
	_actions = actions.count  > 0 ? [actions copy] : @[];

	return self;
}

- (instancetype)initWithErrorTitle:(NSString *)errorTitle
							 image:(UIImage *_Nullable)image
					secondaryImage:(UIImage *_Nullable)secondaryImage
						   actions:(NSArray<DGSErrorBannerAction *> *_Nullable)actions
{
	return [self initWithErrorTitle:errorTitle
				   errorDescription:nil
							  image:image
					 secondaryImage:secondaryImage
							actions:actions];
}

- (instancetype)initWithErrorTitle:(NSString *)errorTitle
							 image:(UIImage *_Nullable)image
					secondaryImage:(UIImage *_Nullable)secondaryImage
{
	return [self initWithErrorTitle:errorTitle
				   errorDescription:nil
							  image:image
					 secondaryImage:secondaryImage
							actions:nil];
}

@end
