#import "UIFont+DGSCustomFont.h"

@implementation UIFont (DGSCustomFont)

// MARK: Text fonts

+ (UIFont *)dgs_regularFontOfSize:(CGFloat)size
{
	return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)dgs_mediumFontOfSize:(CGFloat)size
{
	return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)dgs_boldFontOfSize:(CGFloat)size
{
	return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

// MARK: Display faces fonts

+ (UIFont *)dgs_regularDisplayTypeFontOfSize:(CGFloat)size
{
	return [UIFont fontWithName:@"SuisseIntl-Condensed" size:size];
}

+ (UIFont *)dgs_boldDisplayTypeFontOfSize:(CGFloat)size
{
	return [UIFont fontWithName:@"SuisseIntl-CondensedBold" size:size];
}

// MARK: Auxiliary

/*! Prints available font names to console */
+ (void)dgs_listOfFonts
{
	NSString *output = @"";
    for (NSString *familyName in [UIFont familyNames])
	{
		NSString *title = [NSString stringWithFormat:@"Family name %@", familyName];
		NSString *content = [NSString stringWithFormat:@"Fonts: %@", [UIFont fontNamesForFamilyName:familyName]];
		NSString *chunk = [NSString stringWithFormat:@"%@\n%@\n\n", title, content];
		output = [output stringByAppendingString:chunk];
    }

	NSLog(@"%@", output);
}

@end
