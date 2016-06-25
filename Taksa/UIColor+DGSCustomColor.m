#import "UIColor+DGSCustomColor.h"

/*! Function for creating UIColor instances using their hex
 *
 *  Acceptable formats:
 *      0xAAAAAA
 *      0XAAAAAA
 *      AAAAAA
 *      #AAAAAA
 *  (A – hexidecimal digit)
 **/
static UIColor *colorWithHexString(NSString *hexString);


@implementation UIColor (DGSCustomColor)

+ (UIColor *)dgs_sharkColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#3c3c3c");
	});
	return color;
}

+ (UIColor *)dgs_outerSpaceColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#474747");
	});
	return color;
}

+ (UIColor *)dgs_osloGrayColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#8F9090");
	});
	return color;
}

+ (UIColor *)dgs_tiaraColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#CCD4D8");
	});
	return color;
}

+ (UIColor *)dgs_mysticColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#F3F3F3");
	});
	return color;
}

+ (UIColor *)dgs_webOrangeColor
{
	static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#F8A700");
    });
    return color;
}

+ (UIColor *)dgs_deepCeruleanColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#007BAB");
	});
	return color;
}

+ (UIColor *)dgs_antiFlashWhiteColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#F1F5F6");
	});
	return color;
}

+ (UIColor *)dgs_powderBlueColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#B1D4E3");
	});
	return color;
}

+ (UIColor *)dgs_keyLimePieColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#AFCC26");
	});
	return color;
}

+ (UIColor *)dgs_flamePeaColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#E05F45");
	});
	return color;
}

+ (UIColor *)dgs_apricotWhiteColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#F7F2E0");
	});
	return color;
}

+ (UIColor *)dgs_gunsmokeColor
{
	static UIColor *color = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		color = colorWithHexString(@"#7C7E7D");
	});
	return color;
}

+ (UIColor *)dgs_colorWithString:(NSString *)string
{
	return colorWithHexString(string);
}

@end


// MARK: - Auxiliary

static UIColor *colorWithHex(NSUInteger hex)
{
	return [UIColor colorWithRed:((CGFloat)((hex & 0xFF0000)  >> 16)) / 255.f\
                           green:((CGFloat)((hex & 0xFF00)    >>  8)) / 255.f\
                            blue:((CGFloat)((hex & 0xFF)           )) / 255.f\
                           alpha:1.f];
}

static NSUInteger hexForHexString(NSString *hexString)
{
	BOOL unexpectedHexStringLength = (hexString.length < 6) || (hexString.length > 8);
    if (unexpectedHexStringLength)
	{
        return 0xffffff;
    }

    NSScanner *scanner = [NSScanner scannerWithString:hexString];
	BOOL isFormatWithSharp = (hexString.length == 7) && ([[hexString substringToIndex:1] isEqualToString:@"#"]);
    if (isFormatWithSharp)
	{
        [scanner setScanLocation:1];
    }

    unsigned hex = 0;
    if (![scanner scanHexInt:&hex]) {
        return 0xffffff;
    }

    return hex;
}

static UIColor *colorWithHexString(NSString *hexString)
{
	return colorWithHex(hexForHexString(hexString));
}
