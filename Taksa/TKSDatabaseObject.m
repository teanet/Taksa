#import "TKSDatabaseObject.h"

@implementation TKSDatabaseObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_purposeName = dictionary[@"purpose_name"];
	_name = dictionary[@"name"];
	_fullName = dictionary[@"full_name"];
	_id = dictionary[@"id"];
	_addressName = dictionary[@"address_name"];
	_type = dictionary[@"building"];

	NSDictionary *geometryDictionary = dictionary[@"geometry"];
	NSString *selectionString = geometryDictionary[@"selection"];
	
	CLLocationCoordinate2D coordinate = [TKSDatabaseObject coordinateWithString:selectionString];
	_location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];

	return self;
}

// Потом в категорию
+ (CLLocationCoordinate2D)coordinateWithString:(NSString *)coordinateString
{
	CLLocationCoordinate2D coordinateValue = kCLLocationCoordinate2DInvalid;

	NSCharacterSet *trimmingCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"POINT()"];
	NSString *trimmedString = [coordinateString stringByTrimmingCharactersInSet:trimmingCharacterSet];

	NSArray *pointValuesArray = [trimmedString componentsSeparatedByString:@" "];

	if (pointValuesArray.count == 2)
	{
		CLLocationDegrees longtitude = [pointValuesArray.firstObject doubleValue];
		CLLocationDegrees latitude = [pointValuesArray.lastObject doubleValue];
		coordinateValue = CLLocationCoordinate2DMake(latitude, longtitude);
	}

	return coordinateValue;
}

@end
