#import "TKSTaxiManager.h"

#import "TKSTaxiRow.h"

@implementation TKSTaxiManager

- (TKSTaxiSection *)sectionResultsForRoute:(TKSRoute *)route
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

	TKSTaxiSection *section = [[TKSTaxiSection alloc] initWithRoute:route rows:rows];

	return section;
}

@end
