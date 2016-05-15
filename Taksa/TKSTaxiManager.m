#import "TKSTaxiManager.h"

#import "TKSTaxiRow.h"

@implementation TKSTaxiManager

- (NSArray<TKSTaxiSection *> *)sectionResultsForRoute:(TKSRoute *)route
{
	NSDate *travelDate = [NSDate date];

	NSArray<TKSTaxi *> *sortedTaxies =
		[self.taxies sortedArrayUsingComparator:^NSComparisonResult(TKSTaxi *taxi_1, TKSTaxi *taxi_2) {
			NSInteger price_1 = [taxi_1 priceForDistance:route.distance duration:route.duration travelDate:travelDate];
			NSInteger price_2 = [taxi_2 priceForDistance:route.distance duration:route.duration travelDate:travelDate];
			return price_1 > price_2;
		}];

	NSArray<TKSTaxiRow *> *rows = [[sortedTaxies.rac_sequence
		filter:^BOOL(TKSTaxi *taxi) {
			return [taxi priceForDistance:route.distance duration:route.duration travelDate:travelDate] > 0;
		}]
		map:^TKSTaxiRow *(TKSTaxi *taxi) {
			NSUInteger price = [taxi priceForDistance:route.distance duration:route.duration travelDate:travelDate];
			return [[TKSTaxiRow alloc] initWithTaxi:taxi price:price];
		}].array;

	if (rows.count <= 1) return nil;

	TKSTaxiSection *section = [[TKSTaxiSection alloc] initWithRoute:route rows:[rows subarrayWithRange:NSMakeRange(1, rows.count - 1)]];
	TKSTaxiSection *emptySection = [[TKSTaxiSection alloc] initWithRoute:route rows:@[rows.firstObject]];
	return @[emptySection, section];
}

@end
