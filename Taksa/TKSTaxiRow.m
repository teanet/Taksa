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

@implementation TKSTaxiRow (TKSLocalTaxi)

- (instancetype)initWithTaxi:(TKSTaxi *)taxi price:(NSInteger)price
{
	self = [super init];
	if (self == nil) return nil;

	_type = TKSTaxiModelTypeDefault;
	_name = taxi.operator;
	_contact = taxi.tel.length > 0
		? taxi.tel
		: taxi.site.absoluteString;

	_contact = _contact.length > 0
		? taxi.url.absoluteString
		: @"Нет контакта ='(";

	_price = [NSString stringWithFormat:@"%ld", (long)price];
	_color = taxi.backgroundColor;

	return self;
};

@end
