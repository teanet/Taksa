#import "TKSAPIController.h"

@class TKSDatabaseObject;

@interface TKSAPIController (TKSModels)

/*!
 *	2GIS WebAPI
 */

/*! \return @[TKSSuggest] */
- (RACSignal *)fetchSuggestsForSearchString:(NSString *)searchString
								   regionId:(NSString *)regionId;

/*! \sendNext @[TKSDatabaseObject] */
- (RACSignal *)fetchObjectsForSearchString:(NSString *)searchString
								  regionId:(NSString *)regionId;

/*! \sendNext TKSDatabaseObject */
- (RACSignal *)fetchObjectForObjectId:(NSString *)objectId
							 regionId:(NSString *)regionId;

/*! \sendNext TKSDatabaseObject */
- (RACSignal *)fetchObjectForLocation:(CLLocation *)location
							 regionId:(NSString *)regionId;

/*! \sendNext @[TKSRegion] */
- (RACSignal *)fetchRegions;

/*! \sendNext TKSRegion */
- (RACSignal *)fetchCurrentRegionWithLocation:(CLLocation *)location;

/*!
 *	Taksa™ Server®
 */

/*! \sendNext TKSRoute */
- (RACSignal *)fetchRouteFromObject:(TKSDatabaseObject *)objectFrom
						   toObject:(TKSDatabaseObject *)objectTo
						   regionId:(NSString *)regionId;

/*! \sendNext @[NSDictionary] */
- (RACSignal *)fetchTaxiDictionariesArray;

@end
