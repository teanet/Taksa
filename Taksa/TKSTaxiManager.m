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

	NSMutableArray<TKSTaxiSection *> *sections = [NSMutableArray arrayWithCapacity:2];

	if (rows.count > 0)
	{
		NSString *titleFirst = [NSString stringWithFormat:@"%.1f км, %ld минут", route.distance, (long)route.duration];
		TKSTaxiSection *sectionSuggest = [[TKSTaxiSection alloc] initWithTitle:titleFirst rows:@[rows.firstObject]];

		[sections addObject:sectionSuggest];
	}

	if (rows.count > 1)
	{
		NSArray<TKSTaxiRow *> *rowsDefault = [rows subarrayWithRange:NSMakeRange(1, rows.count - 1)];
		TKSTaxiRow *rowCheapest = [rowsDefault firstObject];
		TKSTaxiRow *rowMostExpensive = [rowsDefault lastObject];
		NSString *titleSecond = [NSString stringWithFormat:@"%ld предложения от %@ до %@ рублей",
			(long)rowsDefault.count, rowCheapest.price, rowMostExpensive.price];
		TKSTaxiSection *sectionList = [[TKSTaxiSection alloc] initWithTitle:titleSecond rows:rowsDefault];

		[sections addObject:sectionList];
	}

	return [sections copy];
}

@end
