#import "TKSAPIController+TKSModels.h"

#import "TKSSuggest.h"
#import "TKSDatabaseObject.h"
#import "TKSTaxiGroupModel.h"
#import "TKSRegion.h"

@implementation TKSAPIController (TKSModels)

// MARK: WebAPI Server

- (RACSignal *)fetchSuggestsForString:(NSString *)searchString
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
		@"type" : @"street,building",
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

- (RACSignal *)fetchObjectForSearchString:(NSString *)searchString
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
		@"type" : @"street,building",
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

- (RACSignal *)fetchTaxiListFromObject:(TKSDatabaseObject *)objectFrom
							  toObject:(TKSDatabaseObject *)objectTo
{
#warning Backend required. Переделать на backend.
	return [RACSignal return:@[[TKSTaxiGroupModel testGroupeSuggest], [TKSTaxiGroupModel testGroupeList]]];
}

@end
