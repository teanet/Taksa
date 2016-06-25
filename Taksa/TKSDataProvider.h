#import "TKSSuggest.h"
#import "TKSDatabaseObject.h"
#import "TKSTaxiSection.h"
#import "TKSRegion.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKSDataProvider : NSObject

@property (nonatomic, strong, nullable) TKSRegion *currentRegion;

+ (instancetype)sharedProvider;

/*! \return @[TKSSuggest] */
- (RACSignal *)fetchSuggestsForSearchString:(NSString *)searchString;
/*! \sendNext @[TKSDatabaseObject] */
- (RACSignal *)fetchObjectsForSearchString:(NSString *)searchString;
/*! \sendNext TKSDatabaseObject */
- (RACSignal *)fetchObjectForObjectId:(NSString *)objectId;
/*! \sendNext TKSDatabaseObject */
- (RACSignal *)fetchObjectForLocation:(CLLocation *)location;

/*! \sendNext @[TKSTaxiSection] */
- (RACSignal *)fetchTaxiListFromObject:(TKSDatabaseObject *)objectFrom
							  toObject:(TKSDatabaseObject *)objectTo;

/*! \sendNext @[TKSRegion] */
- (RACSignal *)fetchRegions;

/*! Side Effect = запоминает текущий регион, и все последующие запросы будут с ним
 *	\sendNext TKSRegion
 */
- (RACSignal *)fetchCurrentRegion;

@end

NS_ASSUME_NONNULL_END
