#import "TKSTaxiSection.h"

@implementation TKSTaxiSection

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
						  searchId:(NSString *)searchId
							 title:(NSString *)title
							  type:(TKSTaxiModelType)type
{
	self = [super init];
	if (self == nil) return nil;

	_title = dictionary[@"title"];
	if (_title.length == 0)
	{
		_title = [title copy];
	}
	
	_summary = dictionary[@"summary"];
	_type = type;
	_searchId = [searchId copy];

	NSArray *taxiDictionariesArray = dictionary[@"results"];
	_rows = [[taxiDictionariesArray rac_sequence]
		map:^TKSTaxiRow *(NSDictionary *taxiDictionary) {
			return [[TKSTaxiRow alloc] initWithDictionary:taxiDictionary summary:_summary searchId:searchId type:type];
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
	NSNumber *searchIdNumber = resultsDictionary[@"id"];
	NSString *searchId = [searchIdNumber stringValue];

	NSString *optimalTitle = [self.class optimalTitleForDistance:distanceNumber time:timeNumber];
	NSString *elseTitle = [self.class elseTitleForSectionDictionary:elseSectionDictionary
														   distance:distanceNumber
															   time:timeNumber];

	TKSTaxiSection *optimalSection = [[TKSTaxiSection alloc] initWithDictionary:optimalSectionDictionary
																	   searchId:searchId
																		  title:optimalTitle
																		   type:TKSTaxiModelTypeSuggest];

	TKSTaxiSection *elseSection = [[TKSTaxiSection alloc] initWithDictionary:elseSectionDictionary
																	searchId:searchId
																	   title:elseTitle
																		type:TKSTaxiModelTypeDefault];
	return @[optimalSection, elseSection];
}

+ (NSString *)optimalTitleForDistance:(NSNumber *)distanceNumber time:(NSNumber *)timeNumber
{

	return [NSString stringWithFormat:@"%.1fкм, %ld минуты",
		[distanceNumber doubleValue]/1000.0,
		timeNumber.integerValue];
}

+ (NSString *)elseTitleForSectionDictionary:(NSDictionary *)sectionDictionary
								   distance:(NSNumber *)distanceNumber
									   time:(NSNumber *)timeNumber
{
	NSArray *operators = sectionDictionary[@"results"];
	NSString *titleLeft = [NSString stringWithFormat:@"%ld предложений", operators.count];
	NSString *titleRight = [NSString stringWithFormat:@"%.1fкм, %ld минуты",
		[distanceNumber doubleValue]/1000.0,
		timeNumber.integerValue];

	return [NSString stringWithFormat:@"%@|%@",titleLeft, titleRight];
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

	return [[TKSTaxiSection alloc] initWithDictionary:testDictionary searchId:nil title:nil type:0];
}

@end

