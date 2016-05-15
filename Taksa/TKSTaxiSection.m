#import "TKSTaxiSection.h"

@interface TKSTaxiSection ()

@property (nonatomic, copy, readwrite) NSArray<TKSTaxiRow *> *rows;

@end

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

- (instancetype)initWithRoute:(TKSRoute *)route rows:(NSArray<TKSTaxiRow *> *)rows
{
	self = [super init];
	if (self == nil) return nil;

	_title = [NSString stringWithFormat:@"%.1f км, %ld минут", route.distance, route.duration];
	_rows = rows;

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

