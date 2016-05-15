#import "TKSTaxiSection.h"

@implementation TKSTaxiSection

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_title = dictionary[@"title"];
	_summary = dictionary[@"summary"];

	NSArray *taxiDictionariesArray = dictionary[@"taxi_list"];
	_rows = [[taxiDictionariesArray rac_sequence]
		 map:^TKSTaxiRow *(NSDictionary *taxiDictionary) {
			 return [[TKSTaxiRow alloc] initWithDictionary:taxiDictionary];
		 }].array;

	return self;
}

@end

@implementation TKSTaxiSection (TKSLocalTaxi)

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray<TKSTaxiRow *> *)rows
{
	self = [super init];
	if (self == nil) return nil;

	_title = [title copy];
	_rows = [rows copy];

	return self;
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

	return [[TKSTaxiSection alloc] initWithDictionary:testDictionary];
}

@end

