#import "DGSErrorBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DGSErrorBannerAutohideMode) {
	DGSErrorBannerAutohideModeManualOnly = 0,
	DGSErrorBannerAutohideModeByTouch,
	DGSErrorBannerAutohideModeByButtonTap
};

@interface DGSErrorBannerVM : NSObject

@property (nonatomic, strong, readonly, nullable) DGSErrorBannerModel *model;

@property (nonatomic, assign, readonly) DGSErrorBannerAutohideMode autohideMode;
@property (nonatomic, copy, readonly, nullable) NSArray<DGSErrorBannerAction *> *actions;
@property (nonatomic, copy, readonly) NSAttributedString *attributedMessage;
@property (nonatomic, copy, readonly) UIImage *imageFront;
@property (nonatomic, copy, readonly) UIImage *imageBack;

- (instancetype)initWithAutohideMode:(DGSErrorBannerAutohideMode)autohideMode NS_DESIGNATED_INITIALIZER;

- (void)showMessage:(NSString *)message;
- (void)showWithModel:(DGSErrorBannerModel *)model;
- (void)hide;

- (void)performActionWithIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
