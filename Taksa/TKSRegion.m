#import "TKSRegion.h"

@implementation TKSRegion

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_id = dictionary[@"id"];
	_title = dictionary[@"title"];
	_code = dictionary[@"code"];

	return self;
}

@end
