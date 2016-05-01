#import "TKSTaxiGroupModel.h"

@implementation TKSTaxiGroupModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_title = dictionary[@"title"];
	_summary = dictionary[@"summary"];

	NSArray *taxiDictionariesArray = dictionary[@"taxi_list"];
	_taxiList = [[taxiDictionariesArray rac_sequence]
		map:^TKSTaxiRow *(NSDictionary *taxiDictionary) {
			return [[TKSTaxiRow alloc] initWithDictionary:taxiDictionary];
		}].array;

	return self;
}

@end

@implementation TKSTaxiGroupModel (TKSTest)

+ (instancetype)testGroupeList
{
	return [TKSTaxiGroupModel testGroupeWithName:@"testGroupeList.json"];
}

+ (instancetype)testGroupeSuggest
{
	return [TKSTaxiGroupModel testGroupeWithName:@"testGroupeSuggest.json"];
}

+ (instancetype)testGroupeWithName:(NSString *)name
{
	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
	NSDictionary *testDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

	return [[TKSTaxiGroupModel alloc] initWithDictionary:testDictionary];
}


@end
