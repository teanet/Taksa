#import "TKSSuggest.h"
#import "TKSTaxiSection.h"
#import "TKSRegion.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKSDataProvider : NSObject

@property (nonatomic, strong, nullable) TKSRegion *currentRegion;

+ (instancetype)sharedProvider;

/*! \return @[TKSSuggest] Переделано! */
- (RACSignal *)fetchSuggestsForSearchString:(NSString *)searchString;

/*! \sendNext TKSSuggest Переделано! */
- (RACSignal *)fetchSuggestForLocation:(CLLocation *)location;

/*! \sendNext @[TKSTaxiSection] Переделано!  */
- (RACSignal *)fetchTaxiListFromObject:(TKSSuggest *)objectFrom
							  toObject:(TKSSuggest *)objectTo;

/*! \sendNext @[TKSRegion] Переделано! */
- (RACSignal *)fetchRegions;

/*! Side Effect = запоминает текущий регион, и все последующие запросы будут с ним Переделано!
 *	\sendNext TKSRegion
 */
- (RACSignal *)fetchCurrentRegion;

- (void)sendAnalyticsForType:(NSString *)type body:(NSDictionary *_Nullable)bodyDictionary;

- (void)addSuggestToHistory:(TKSSuggest *)suggest;
- (NSArray<TKSSuggest *> *)historyList;

@end

NS_ASSUME_NONNULL_END
