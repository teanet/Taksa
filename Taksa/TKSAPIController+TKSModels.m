#import "TKSAPIController+TKSModels.h"

#import "TKSSuggest.h"
#import "TKSDatabaseObject.h"
#import "TKSTaxiSection.h"
#import "TKSRegion.h"
#import "TKSTaxi.h"
#import "TKSRoute.h"

@implementation TKSAPIController (TKSModels)

// MARK: WebAPI Server

- (RACSignal *)fetchSuggestsForSearchString:(NSString *)searchString
								   regionId:(NSString *)regionId
{
	NSCParameterAssert(regionId);

	if ((searchString.length == 0) || (regionId.length == 0)) return [RACSignal return:nil];

	NSDictionary *params = @{
		@"key": self.webAPIKey,
		@"type": @"default",//@"street",
		@"region_id" : regionId,
		@"lang" : @"ru",
		@"output" : @"json",
		@"types" : @"adm_div.settlement,adm_div.city,address,street,branch",
		@"q": searchString,
	};

	return [[self GET:@"suggest/list" service:TKSServiceWebAPI params:params]
		map:^NSArray<TKSSuggest *> *(NSDictionary *responseObject) {
			NSArray<TKSSuggest *> *returnArray = nil;

			if ([responseObject isKindOfClass:[NSDictionary class]])
			{
				NSDictionary *resultDictionary = responseObject[@"result"];
				NSArray *hintDictionaries = resultDictionary[@"items"];
				returnArray = [hintDictionaries.rac_sequence

							   map:^TKSSuggest *(NSDictionary *hintDictionary) {
								   return [[TKSSuggest alloc] initWithDictionary:hintDictionary];
							   }].array;
			}

			return returnArray;
		}];
}

- (RACSignal *)fetchObjectsForSearchString:(NSString *)searchString
								  regionId:(NSString *)regionId;
{
	NSCParameterAssert(regionId);

	if ((searchString.length == 0) || (regionId.length == 0)) return [RACSignal return:nil];

	NSDictionary *params = @{
		@"key": self.webAPIKey,
		@"region_id" : regionId,
		@"lang" : @"ru",
		@"output" : @"json",
		@"q" : searchString,
		@"type" : @"building",
		@"fields": @"items.geometry.selection",
	};

	return [[self GET:@"geo/search" service:TKSServiceWebAPI params:params]
			map:^NSArray <TKSDatabaseObject *> *(NSDictionary *responseObject) {
				NSArray <TKSDatabaseObject *> *returnArray = nil;

				if ([responseObject isKindOfClass:[NSDictionary class]])
				{
					NSDictionary *resultDictionary = responseObject[@"result"];
					NSArray<NSDictionary *> *itemDictionaries = resultDictionary[@"items"];

					returnArray = [itemDictionaries.rac_sequence
								   map:^TKSDatabaseObject *(NSDictionary *objectDictionary) {
									   return [[TKSDatabaseObject alloc] initWithDictionary:objectDictionary];
								   }].array;
				}
				
				return returnArray;
			}];
}

- (RACSignal *)fetchObjectForObjectId:(NSString *)objectId
							 regionId:(NSString *)regionId
{
	NSCParameterAssert(objectId);
	NSCParameterAssert(regionId);

	if ((objectId.length == 0) || (regionId.length == 0)) return [RACSignal return:nil];

	NSDictionary *params = @{
		@"key": self.webAPIKey,
		@"id": objectId,
		@"region_id" : regionId,
		@"lang" : @"ru",
		@"output" : @"json",
		@"fields": @"items.geometry.selection",
	};

	return [[self GET:@"geo/get" service:TKSServiceWebAPI params:params]
		map:^TKSDatabaseObject *(NSDictionary *responseObject) {
			TKSDatabaseObject *returnObject = nil;
			
			if ([responseObject isKindOfClass:[NSDictionary class]])
			{
				NSDictionary *resultDictionary = responseObject[@"result"];
				NSArray *itemsDictionaries = resultDictionary[@"items"];
				NSDictionary *objectDictionary = itemsDictionaries.firstObject;
				if ([objectDictionary isKindOfClass:[NSDictionary class]])
				{
					returnObject = [[TKSDatabaseObject alloc] initWithDictionary:objectDictionary];
				}
			}

			return returnObject;
		}];
}

- (RACSignal *)fetchObjectForLocation:(CLLocation *)location
							 regionId:(NSString *)regionId
{
	NSCParameterAssert(location);
	NSCParameterAssert(regionId);

	if ((!location) || (regionId.length == 0)) return [RACSignal return:nil];

	NSString *pointString = [NSString stringWithFormat:@"%f,%f",
		location.coordinate.longitude, location.coordinate.latitude];
	NSDictionary *params = @{
		@"key": self.webAPIKey,
		@"region_id" : regionId,
		@"lang" : @"ru",
		@"output" : @"json",
		@"point" : pointString,
		@"type" : @"building",
		@"radius" : @"1",
		@"fields": @"items.geometry.selection",
	};

	return [[self GET:@"geo/search" service:TKSServiceWebAPI params:params]
		map:^TKSDatabaseObject *(NSDictionary *responseObject) {
			TKSDatabaseObject *returnObject = nil;

			if ([responseObject isKindOfClass:[NSDictionary class]])
			{
				NSDictionary *resultDictionary = responseObject[@"result"];
				NSArray *itemsDictionaries = resultDictionary[@"items"];
				NSDictionary *objectDictionary = itemsDictionaries.firstObject;
				if ([objectDictionary isKindOfClass:[NSDictionary class]])
				{
					returnObject = [[TKSDatabaseObject alloc] initWithDictionary:objectDictionary];
				}
			}
			
			return returnObject;
		}];
}

// http://catalog.api.2gis.ru/2.0/region/list?key=ruczoy1743
- (RACSignal *)fetchRegions
{
	NSDictionary *params = @{
		@"key": self.webAPIKey,
		@"lang" : @"ru",
		@"output" : @"json",
		@"locale" : @"ru_RU",
		@"locale_filter" : @"ru_RU",
	};

	return [[self GET:@"region/list" service:TKSServiceWebAPI params:params]
			map:^NSArray<TKSRegion *> *(NSDictionary *responseObject) {
				NSArray<TKSRegion *> *returnRegions = nil;

				if ([responseObject isKindOfClass:[NSDictionary class]])
				{
					NSDictionary *resultDictionary = responseObject[@"result"];
					NSArray *itemDictionaries = resultDictionary[@"items"];

					returnRegions = [itemDictionaries.rac_sequence
						map:^TKSRegion *(NSDictionary *regionDictionary) {
							return[[TKSRegion alloc] initWithDictionary:regionDictionary];
						}].array;
				}
				
				return returnRegions;
			}];
}

//http://catalog.api.2gis.ru/2.0/region/search?q=82.921663,55.030195&key=ruczoy1743
- (RACSignal *)fetchCurrentRegionWithLocation:(CLLocation *)location
{
	if (!location) return [RACSignal return:nil];

	NSString *locationString = [NSString stringWithFormat:@"%f,%f",
		location.coordinate.longitude, location.coordinate.latitude];

	NSDictionary *params = @{
		@"key": self.webAPIKey,
		@"lang" : @"ru",
		@"output" : @"json",
		@"q" : locationString
	};

	return [[self GET:@"region/search" service:TKSServiceWebAPI params:params]
		map:^TKSRegion *(NSDictionary *responseObject) {
			TKSRegion *returnRegion = nil;

			if ([responseObject isKindOfClass:[NSDictionary class]])
			{
				NSDictionary *resultDictionary = responseObject[@"result"];
				NSArray *itemsDictionaries = resultDictionary[@"items"];
				NSDictionary *regionDictionary = itemsDictionaries.firstObject;
				if ([regionDictionary isKindOfClass:[NSDictionary class]])
				{
					returnRegion = [[TKSRegion alloc] initWithDictionary:regionDictionary];
				}
			}
			
			return returnRegion;
		}];
}

// MARK: Taksa Server

// catalog.api.2gis.ru/2.0/transport/calculate_directions?waypoints=82.645277+54.694943%2C82.84240722656251+54.992585288467666%2C82.994843+54.989434&routing_type=optimal_statistic%2Cshortest&region_id=1&key=ruczoy1743
- (RACSignal *)fetchRouteFromObject:(TKSDatabaseObject *)objectFrom
						   toObject:(TKSDatabaseObject *)objectTo
						   regionId:(NSString *)regionId
{
	if (!objectFrom || !objectTo || (regionId.length == 0)) return [RACSignal return:nil];

	NSString *locationFromString = [NSString stringWithFormat:@"%f+%f",
		objectFrom.location.coordinate.longitude, objectFrom.location.coordinate.latitude];
	NSString *locationToString = [NSString stringWithFormat:@"%f+%f",
		objectTo.location.coordinate.longitude, objectTo.location.coordinate.latitude];

	NSString *waypoints = [NSString stringWithFormat:@"%@,%@", locationFromString, locationToString];

	// Костыль, чтобы обойти косяк в API, когда она не понимает экодированный +
	NSString *queryString = [NSString stringWithFormat:@"transport/calculate_directions?key=%@&lang=ru&output=json&region_id=%@&routing_type=optimal_statistic,shortest&waypoints=%@", self.webAPIKey, regionId, waypoints];

	return [[self GET:queryString service:TKSServiceWebAPI params:nil]
			map:^TKSRoute *(NSDictionary *responseObject) {
				TKSRoute *returnRoute = nil;

				if ([responseObject isKindOfClass:[NSDictionary class]])
				{
					NSDictionary *resultDictionary = responseObject[@"result"];
					NSArray *itemDictionaries = resultDictionary[@"items"];
					NSDictionary *routeDictionary = itemDictionaries.firstObject;
					if ([routeDictionary isKindOfClass:[NSDictionary class]])
					{
						returnRoute = [[TKSRoute alloc] initWithDictionary:routeDictionary];
					}
				}
				
				return returnRoute;
			}];
}

- (RACSignal *)fetchTaxiDictionariesArray
{
	return [[[self GET:self.taxiProvidersFileName service:TKSServiceDropbox params:nil]
		filter:^BOOL(id responseObject) {
			return [responseObject isKindOfClass:[NSArray class]];
		}]
		ignore:nil];
}

@end
