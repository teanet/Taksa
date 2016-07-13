#import "TKSAPIController.h"

@class TKSSuggest;

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
- (RACSignal *)fetchTaxiResultsFromObject:(TKSSuggest *)suggestFrom
								 toObject:(TKSSuggest *)suggestTo
								 regionId:(NSString *)regionId;

/*! \sendNext @[TKSTaxiSection] */
- (RACSignal *)fetchAnalyticsResultForType:(NSString *)type
									  body:(NSDictionary *)bodyDictionary
								  regionId:(NSString *)regionId;

@end
