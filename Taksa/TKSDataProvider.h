#import "TKSSuggestObject.h"
#import "TKSSuggestObject.h"
#import "TKSTaxiSection.h"
#import "TKSRegion.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKSDataProvider : NSObject

@property (nonatomic, strong, nullable) TKSRegion *currentRegion;

+ (instancetype)sharedProvider;

/*! \return @[TKSSuggestObject] Переделано! */
- (RACSignal *)fetchSuggestsForSearchString:(NSString *)searchString;

/*! \sendNext TKSSuggestObject Переделано! */
- (RACSignal *)fetchSuggestForLocation:(CLLocation *)location;

/*! \sendNext @[TKSTaxiSection] */
- (RACSignal *)fetchTaxiListFromObject:(TKSSuggestObject *)objectFrom
							  toObject:(TKSSuggestObject *)objectTo;

/*! \sendNext @[TKSRegion] Переделано! */
- (RACSignal *)fetchRegions;

/*! Side Effect = запоминает текущий регион, и все последующие запросы будут с ним Переделано!
 *	\sendNext TKSRegion
 */
- (RACSignal *)fetchCurrentRegion;

@end

NS_ASSUME_NONNULL_END
