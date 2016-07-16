#import "DGSErrorBannerVM.h"

extern CGFloat const kDGSErrorBannerImageWidth;
extern CGFloat const kDGSErrorBannerSecondaryImageWidth;

@interface DGSErrorBannerView : UIView

@property (nonatomic, strong, readonly) DGSErrorBannerVM *viewModel;

- (instancetype)initWithViewModel:(DGSErrorBannerVM *)viewModel
					containerView:(UIView *)containerView NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithViewModel:(DGSErrorBannerVM *)viewModel;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
