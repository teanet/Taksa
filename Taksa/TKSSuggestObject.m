#import "TKSSuggestObject.h"

@implementation TKSSuggestObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_id = dictionary[@"id"];
	_type = dictionary[@"type"];
	_typeText = dictionary[@"type_text"];
	_text = dictionary[@"text"];

	return self;
}

@end
