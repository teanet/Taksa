NS_ASSUME_NONNULL_BEGIN

@interface DGSErrorBannerAction : NSObject

@property (nonatomic, strong, readonly) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image
				actionHandler:(dispatch_block_t)actionHandler;

@end

@interface DGSErrorBannerModel : NSObject

@property (nonatomic, copy, readonly) NSString *errorTitle;
@property (nonatomic, copy, readonly) NSString *errorDescription;
@property (nonatomic, strong, readonly, nullable) UIImage *image;
@property (nonatomic, copy, readonly, nullable) UIImage *secondaryImage;
@property (nonatomic, copy, readonly) NSArray<DGSErrorBannerAction *> *actions;

- (instancetype)initWithErrorTitle:(NSString *)errorTitle
				  errorDescription:(NSString *_Nullable)errorDescription
							 image:(UIImage *_Nullable)image
					secondaryImage:(UIImage *_Nullable)secondaryImage
						   actions:(NSArray<DGSErrorBannerAction *> *_Nullable)actions NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithErrorTitle:(NSString *)errorTitle
							 image:(UIImage *_Nullable)image
					secondaryImage:(UIImage *_Nullable)secondaryImage
						   actions:(NSArray<DGSErrorBannerAction *> *_Nullable)actions;

- (instancetype)initWithErrorTitle:(NSString *)errorTitle
							 image:(UIImage *_Nullable)image
					secondaryImage:(UIImage *_Nullable)secondaryImage;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END


