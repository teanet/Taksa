#import "TKSSuggest.h"
#import "TKSDatabaseObject.h"
#import "TKSTaxiGroupModel.h"
#import "TKSRegion.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKSDataProvider : NSObject

@property (nonatomic, strong, nullable) TKSRegion *currentRegion;

+ (instancetype)sharedProvider;

/*! \return NSArray<TKSSuggest *> */
- (RACSignal *)fetchSuggestsForString:(NSString *)searchString;

/*! \sendNext TKSDatabaseObject */
- (RACSignal *)fetchObjectForObjectId:(NSString *)objectId;
/*! \sendNext TKSDatabaseObject */
- (RACSignal *)fetchObjectForLocation:(CLLocation *)location;
/*! \sendNext TKSDatabaseObject */
- (RACSignal *)fetchObjectForSearchString:(NSString *)searchString;

/*! \sendNext @[TKSTaxiGroupModel] */
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
