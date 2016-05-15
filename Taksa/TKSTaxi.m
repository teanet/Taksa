#import "TKSTaxi.h"

#import "NSDateFormatter+TKSTaxiProvider.h"
#import "UIColor+DGSCustomColor.h"

@interface TKSTaxi ()

@property (nonatomic, copy, readonly) NSDate *timeFrom;
@property (nonatomic, copy, readonly) NSDate *timeTo;
@property (nonatomic, copy, readonly) NSDate *dayFrom;
@property (nonatomic, copy, readonly) NSDate *dayTo;

@property (nonatomic, assign, readonly) NSInteger start;
@property (nonatomic, assign, readonly) NSInteger costKm;
@property (nonatomic, assign, readonly) NSInteger costMinute;
@property (nonatomic, assign, readonly) NSInteger costMinimum;
@property (nonatomic, assign, readonly) NSInteger includeKm;
@property (nonatomic, assign, readonly) NSInteger includeMinutes;

@end

@implementation TKSTaxi

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_operator = dictionary[@"operator"];

	NSString *telString = dictionary[@"tel"];
	_tel = ([telString isKindOfClass:[NSString class]])
		? telString
		: nil;

	NSString *urlString = dictionary[@"url"];
	if ([urlString isKindOfClass:[NSString class]])
	{
		_url = [NSURL URLWithString:urlString];
	}

	NSString *siteString = dictionary[@"site"];
	if ([siteString isKindOfClass:[NSString class]])
	{
		_site = [NSURL URLWithString:siteString];
	}

	NSString *bgColorString = dictionary[@"background_color"];
	_backgroundColor = [UIColor dgs_colorWithString:bgColorString];

	NSString *textColorString = dictionary[@"text_color"];
	_textColor = [UIColor dgs_colorWithString:textColorString];

	NSString *timeFromString = dictionary[@"time_from"];
	_timeFrom = [[NSDateFormatter tks_timeFormatter] dateFromString:timeFromString];

	NSString *timeToString = dictionary[@"time_to"];
	_timeTo = [[NSDateFormatter tks_timeFormatter] dateFromString:timeToString];

	NSString *dayFromString = dictionary[@"day_from"];
	_dayFrom = [[NSDateFormatter tks_dateFormatter] dateFromString:dayFromString];

	NSString *dayToString = dictionary[@"day_to"];
	_dayTo = [[NSDateFormatter tks_dateFormatter] dateFromString:dayToString];

	_start = [dictionary[@"start"] integerValue];
	_costKm = [dictionary[@"1km"] integerValue];
	_costMinute = [dictionary[@"1min"] integerValue];
	_costMinimum = [dictionary[@"min_value"] integerValue];
	_includeKm = [dictionary[@"include_km"] integerValue];
	_includeMinutes = [dictionary[@"include_min"] integerValue];

	return self;
}

@end

@implementation TKSTaxi (TKSRouteCostCalculation)

- (NSInteger)priceForDistance:(NSInteger)distance duration:(NSTimeInterval)duration travelDate:(NSDate *)date
{
	// Вычитаем заложенные в стоимость подачи километры/минуты
	double effectiveDistance = (double)distance - (double)self.includeKm;
	double effectiveDuration = (double)duration - (double)self.includeMinutes;

	// Складываем минималку и рассчитанную стоимость поездки
	double cost = (double)self.start;
	cost += (double)self.costKm * (double)effectiveDistance;
	cost +=  (double)self.costMinute * (double)effectiveDuration;

	NSInteger costInRubles = (NSInteger) cost > self.costMinimum ?: self.costMinimum;

	return costInRubles;
}

@end
