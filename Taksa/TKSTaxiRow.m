#import "TKSTaxiRow.h"

#import "UIColor+DGSCustomColor.h"

/*!
 {
	"operator": {
		 "url": null,
		 "site": {
			 "value": "http://gett.com/ru/",
			 "text": "gett.com"
		 },
		 "background_color": "#70B44A",
		 "text_color": "#fff",
		 "title": "Gett Комфорт",
		 "phone": {
			 "value": "+",
			 "text": "+"
		 }
	},
	"price": 158
 }
 */

@implementation TKSTaxiRow

- (instancetype)initWithDictionary:(NSDictionary *)dictionary type:(TKSTaxiModelType)type
{
	self = [super init];
	if (self == nil) return nil;

	_type = type;

	NSDictionary *operatorDictionary = dictionary[@"operator"];
	_title = operatorDictionary[@"title"];
	_summary = dictionary[@"summary"];

	// URL
	NSDictionary *siteDictionary = operatorDictionary[@"site"];
	_site = siteDictionary[@"text"];
	_siteUrlString = siteDictionary[@"value"];

	NSString *colorString = operatorDictionary[@"background_color"];
	_color = [UIColor dgs_colorWithString:colorString];
	NSString *textColorString = operatorDictionary[@"text_color"];
	_textColor = [UIColor dgs_colorWithString:textColorString];

	// Phone
	NSDictionary *phoneDictionary = operatorDictionary[@"phone"];
	_phoneText = phoneDictionary[@"text"];
	_phoneValue = phoneDictionary[@"value"];

	NSNumber *priceNumber = dictionary[@"price"];
	_price = [priceNumber stringValue];

	return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	return nil;
}

@end
