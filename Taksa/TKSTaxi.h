#import "TKSSerializableProtocol.h"

@interface TKSTaxi : NSObject <TKSSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *operator;
@property (nonatomic, copy, readonly) NSString *tel;
@property (nonatomic, copy, readonly) NSURL *site;
@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) UIColor *backgroundColor;
@property (nonatomic, copy, readonly) UIColor *textColor;

@end

@interface TKSTaxi (TKSRouteCostCalculation)

/*! Возвращает стоимость в рублях.
 *	Если -1, значит провайдер не может предоставить такси с этими параметрами.
 *	\param distance - в километрах, duration - в минутах
 */
- (NSInteger)priceForDistance:(NSInteger)distance duration:(NSTimeInterval)duration travelDate:(NSDate *)date;

@end
