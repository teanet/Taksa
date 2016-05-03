#import "TKSRegion.h"

@implementation TKSRegion

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_id = dictionary[@"id"];
	_name = dictionary[@"name"];
	_type = dictionary[@"type"];

	return self;
}

@end
