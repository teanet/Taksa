#import "TKSAPIController.h"

@class TKSSuggestObject;

@interface TKSAPIController (TKSModels)

/*!
 *	Taksa™ Server®
 */

/*! \sendNext @[TKSRegion] Переделано! */
- (RACSignal *)fetchRegions;

/*! \sendNext TKSRegion Переделано! */
- (RACSignal *)fetchCurrentRegionWithLocation:(CLLocation *)location;

/*! \return @[TKSSuggestObject] Переделано! */
- (RACSignal *)fetchSuggestsForSearchString:(NSString *)searchString
								   regionId:(NSString *)regionId;

/*! \sendNext TKSSuggestObject */
- (RACSignal *)fetchSuggestForLocation:(CLLocation *)location
							  regionId:(NSString *)regionId;

/*! \sendNext @[TKSTaxiSection] */
- (RACSignal *)fetchTaxiResultsFromObject:(TKSSuggestObject *)suggestFrom
								 toObject:(TKSSuggestObject *)suggestTo
								 regionId:(NSString *)regionId;

@end
