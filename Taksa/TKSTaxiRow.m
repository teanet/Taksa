#import "TKSTaxiRow.h"

#import "UIColor+DGSCustomColor.h"

@implementation TKSTaxiRow

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_type = [dictionary[@"type"] isEqualToString:@"suggest"]
	? TKSTaxiModelTypeSuggest
	: TKSTaxiModelTypeDefault;

	_name = dictionary[@"name"];
	_contact = dictionary[@"contact"];
	_price = dictionary[@"price"];
	_summary = dictionary[@"summary"];
	_color = [UIColor dgs_colorWithString:dictionary[@"color"]];

	return self;
}

@end
