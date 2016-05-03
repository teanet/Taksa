#import "TKSAPIController.h"

@class TKSDatabaseObject;

@interface TKSAPIController (TKSModels)

/*!
 *	2GIS WebAPI
 */

/*! \return NSArray<TKSSuggest *> */
- (RACSignal *)fetchSuggestsForString:(NSString *)searchString
							 regionId:(NSString *)regionId;

/*! \sendNext TKSDatabaseObject */
- (RACSignal *)fetchObjectForObjectId:(NSString *)objectId
							 regionId:(NSString *)regionId;

/*! \sendNext TKSDatabaseObject */
- (RACSignal *)fetchObjectForLocation:(CLLocation *)location
							 regionId:(NSString *)regionId;

/*! \sendNext TKSDatabaseObject */
- (RACSignal *)fetchObjectForSearchString:(NSString *)searchString
								 regionId:(NSString *)regionId;

/*! \sendNext @[TKSRegion] */
- (RACSignal *)fetchRegions;

/*! \sendNext TKSRegion */
- (RACSignal *)fetchCurrentRegionWithLocation:(CLLocation *)location;

/*!
 *	Taksa™ Server®
 */

/*! \sendNext @[TKSTaxiGroupModel] */
- (RACSignal *)fetchTaxiListFromObject:(TKSDatabaseObject *)objectFrom
							  toObject:(TKSDatabaseObject *)objectTo;

@end
