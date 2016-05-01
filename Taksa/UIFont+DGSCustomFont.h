@interface UIFont (DGSCustomFont)

/*! Application-wide text fonts */
+ (UIFont *)dgs_regularFontOfSize:(CGFloat)size;
+ (UIFont *)dgs_mediumFontOfSize:(CGFloat)size;
+ (UIFont *)dgs_boldFontOfSize:(CGFloat)size;

/*! Display faces fonts */
+ (UIFont *)dgs_regularDisplayTypeFontOfSize:(CGFloat)size;
+ (UIFont *)dgs_boldDisplayTypeFontOfSize:(CGFloat)size;

@end
