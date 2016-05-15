#import "TKSRoute.h"

@implementation TKSRoute

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_duration = (NSInteger)([dictionary[@"total_duration"] integerValue] / 60);
	_distance = [dictionary[@"total_distance"] doubleValue] / 1000.0;

	return self;
}

@end
