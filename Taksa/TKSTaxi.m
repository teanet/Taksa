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

	NSString *bgColorString = dictionary[@"bacground_color"];
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
	// Если тариф неподходящий по времени, возвращаем -1 = ошибка
	if(![self isTimeOfDate:date betweenStartDate:self.timeFrom endDate:self.timeTo]) return -1;

	// Если день недели не тот, возвращаем -1 = ошибка
	if(![self isDayOfDate:date betweenStartDate:self.dayFrom endDate:self.dayTo]) return -1;

	// Вычитаем заложенные в стоимость подачи километры/минуты
	double effectiveDistance = (double)distance - (double)self.includeKm;
	double effectiveDuration = (double)duration - (double)self.includeMinutes;

	// Складываем минималку и рассчитанную стоимость поездки
	double cost = (double)self.start;
	cost += (double)self.costKm * (double)effectiveDistance;
	cost +=  (double)self.costMinute * (double)effectiveDuration;

	NSInteger costInRubles = (NSInteger) cost > self.costMinimum ? cost : self.costMinimum;

	return costInRubles;
}

- (NSDate *)dateByNeutralizingDateComponentsOfDate:(NSDate *)originalDate
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

	// Get the components for this date
	NSDateComponents *components = [gregorian components:  (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate: originalDate];

	// Set the year, month and day to some values (the values are arbitrary)
	[components setYear:2000];
	[components setMonth:1];
	[components setDay:1];

	return [gregorian dateFromComponents:components];
}

- (BOOL)isDayOfDate:(NSDate *)targetDate betweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
	NSDateComponents *componentTarget = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:targetDate];
	NSDateComponents *componentStart = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:startDate];
	NSDateComponents *componentEnd = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:endDate];

	NSInteger weekDayTarget = [self normalizedDayFromYankeeDay:componentTarget.weekday];
	NSInteger weekDayStart = [self normalizedDayFromYankeeDay:componentStart.weekday];
	NSInteger weekDayEnd = [self normalizedDayFromYankeeDay:componentEnd.weekday];

	return ((weekDayTarget >= weekDayStart) && (weekDayTarget <= weekDayEnd));
}

- (NSInteger)normalizedDayFromYankeeDay:(NSInteger)weekday
{
	NSInteger normalizedWeekday = weekday - 1;
	return normalizedWeekday == 0 ? 7 : normalizedWeekday;
}

- (BOOL)isTimeOfDate:(NSDate *)targetDate betweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
	if (!targetDate || !startDate || !endDate)
	{
		return NO;
	}

	// Make sure all the dates have the same date component.
	NSDate *newStartDate = [self dateByNeutralizingDateComponentsOfDate:startDate];
	NSDate *newEndDate = [self dateByNeutralizingDateComponentsOfDate:endDate];
	NSDate *newTargetDate = [self dateByNeutralizingDateComponentsOfDate:targetDate];

	// Compare the target with the start and end dates
	NSComparisonResult compareTargetToStart = [newTargetDate compare:newStartDate];
	NSComparisonResult compareTargetToEnd = [newTargetDate compare:newEndDate];

	return (compareTargetToStart == NSOrderedDescending && compareTargetToEnd == NSOrderedAscending);
}

@end
