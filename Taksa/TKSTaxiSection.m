#import "TKSTaxiSection.h"

@implementation TKSTaxiSection

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
						  distance:(NSNumber *)distance
							  time:(NSNumber *)time
							  type:(TKSTaxiModelType)type
{
	self = [super init];
	if (self == nil) return nil;

	_title = dictionary[@"title"];
	_summary = dictionary[@"summary"];
	_distance = [distance stringValue];
	_time = [time stringValue];
	_type = type;

	NSArray *taxiDictionariesArray = dictionary[@"results"];
	_rows = [[taxiDictionariesArray rac_sequence]
		map:^TKSTaxiRow *(NSDictionary *taxiDictionary) {
			return [[TKSTaxiRow alloc] initWithDictionary:taxiDictionary type:type];
		}].array;

	return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	return nil;
}

@end

@implementation NSArray (TKSTaxiSection)

+ (NSArray<TKSTaxiSection *> *)tks_sectionsWithDictionary:(NSDictionary *)dictionary
{
	NSDictionary *metaDictionary = dictionary[@"meta"];
	NSNumber *distanceNumber = metaDictionary[@"distance"];
	NSNumber *timeNumber = metaDictionary[@"time"];

	NSDictionary *resultsDictionary = dictionary[@"results"];
	NSDictionary *optimalSectionDictionary = resultsDictionary[@"optimal"];
	NSDictionary *elseSectionDictionary = resultsDictionary[@"else"];

	TKSTaxiSection *optimalSection = [[TKSTaxiSection alloc] initWithDictionary:optimalSectionDictionary
																	   distance:distanceNumber
																		   time:timeNumber
																		   type:TKSTaxiModelTypeSuggest];

	TKSTaxiSection *elseSection = [[TKSTaxiSection alloc] initWithDictionary:elseSectionDictionary
																	distance:distanceNumber
																		time:timeNumber
																		type:TKSTaxiModelTypeDefault];
	return @[optimalSection, elseSection];
}

@end

@implementation TKSTaxiSection (TKSTest)

+ (instancetype)testGroupeList
{
	return [TKSTaxiSection testGroupeWithName:@"testGroupeList.json"];
}

+ (instancetype)testGroupeSuggest
{
	return [TKSTaxiSection testGroupeWithName:@"testGroupeSuggest.json"];
}

+ (instancetype)testGroupeWithName:(NSString *)name
{
	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
	NSDictionary *testDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

	return [[TKSTaxiSection alloc] initWithDictionary:testDictionary distance:nil time:nil type:0];
}

@end

