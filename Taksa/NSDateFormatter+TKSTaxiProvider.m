#import "NSDateFormatter+TKSTaxiProvider.h"

@implementation NSDateFormatter (TKSTaxiProvider)

+ (NSDateFormatter *)tks_dateFormatter
{
	static dispatch_once_t onceToken;
	static NSDateFormatter *dateFormatter;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"dd.MM.yyyy"];
		[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
	});

	return dateFormatter;
}

+ (NSDateFormatter *)tks_timeFormatter
{
	static dispatch_once_t onceToken;
	static NSDateFormatter *dateFormatter;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"HH:mm:ss"];
		[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
	});

	return dateFormatter;
}

@end
