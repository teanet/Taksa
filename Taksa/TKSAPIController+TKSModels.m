#import "TKSAPIController+TKSModels.h"

#import "TKSSuggestObject.h"
#import "TKSTaxiSection.h"
#import "TKSRegion.h"
#import "TKSTaxi.h"
#import "TKSRoute.h"

@implementation TKSAPIController (TKSModels)

// MARK: Taksa Server

// http://10.154.18.111:8080/taksa/api/1.0/regions
- (RACSignal *)fetchRegions
{
	return [[self GET:@"regions" params:nil]
		map:^NSArray<TKSRegion *> *(NSDictionary *responseObject) {
			NSArray<TKSRegion *> *returnRegions = nil;

			if ([responseObject isKindOfClass:[NSDictionary class]])
			{
				NSArray *itemDictionaries = responseObject[@"results"];

				returnRegions = [itemDictionaries.rac_sequence
					map:^TKSRegion *(NSDictionary *regionDictionary) {
						return[[TKSRegion alloc] initWithDictionary:regionDictionary];
					}].array;
			}

			return returnRegions;
		}];
}

// /taksa/api/1.0/regions/by-location?lon=14.88&lat=228
- (RACSignal *)fetchCurrentRegionWithLocation:(CLLocation *)location
{
	if (!location) return [RACSignal return:nil];

	NSDictionary *params = @{
		@"lon" : [NSString stringWithFormat:@"%f", location.coordinate.longitude],
		@"lat" : [NSString stringWithFormat:@"%f", location.coordinate.latitude],
	};

	return [[self GET:@"regions/by-location" params:params]
		map:^TKSRegion *(NSDictionary *responseObject) {
			TKSRegion *returnRegion = nil;

			if ([responseObject isKindOfClass:[NSDictionary class]])
			{
				NSArray *itemsDictionaries = responseObject[@"results"];
				NSDictionary *regionDictionary = itemsDictionaries.firstObject;
				if ([regionDictionary isKindOfClass:[NSDictionary class]])
				{
					returnRegion = [[TKSRegion alloc] initWithDictionary:regionDictionary];
				}
			}
			
			return returnRegion;
		}];
}

// 10.154.18.111:8080/taksa/api/1.0/address/suggest?region_id=1&q=красный
- (RACSignal *)fetchSuggestsForSearchString:(NSString *)searchString
								   regionId:(NSString *)regionId
{
	NSCParameterAssert(regionId);

	if ((searchString.length == 0) || (regionId.length == 0)) return [RACSignal return:nil];

	NSDictionary *params = @{
		@"region_id" : regionId,
		@"q": searchString,
	};

	return [[self GET:@"address/suggest" params:params]
		flattenMap:^RACStream *(NSDictionary *responseObject) {
			return [TKSAPIController fetchSuggestObjectsFromResponseDictionary:responseObject];
		}];
}

// \sendNext @[TKSSuggestObject]
+ (RACSignal *)fetchSuggestObjectsFromResponseDictionary:(NSDictionary *)responseDictionary
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSArray<TKSSuggestObject *> *returnArray = nil;

		if ([responseDictionary isKindOfClass:[NSDictionary class]])
		{
			NSArray *hintDictionaries = responseDictionary[@"results"];
			returnArray = [hintDictionaries.rac_sequence
						   map:^TKSSuggestObject *(NSDictionary *hintDictionary) {
							   return [[TKSSuggestObject alloc] initWithDictionary:hintDictionary];
						   }].array;
		}

		[subscriber sendNext:returnArray];
		[subscriber sendCompleted];

		return nil;
	}];
}

// /taksa/api/1.0/address/suggest/by-location?lon=14.88&lat=228
- (RACSignal *)fetchSuggestForLocation:(CLLocation *)location
							  regionId:(NSString *)regionId
{
	NSCParameterAssert(location);
	NSCParameterAssert(regionId);

	if ((!location) || (regionId.length == 0)) return [RACSignal return:nil];

	NSDictionary *params = @{
		@"region_id" : regionId,
		@"lon" : [NSString stringWithFormat:@"%f", location.coordinate.longitude],
		@"lat" : [NSString stringWithFormat:@"%f", location.coordinate.latitude],
	};

	return [[self GET:@"suggest/by-location" params:params]
		flattenMap:^RACStream *(NSDictionary *responseObject) {
			return [TKSAPIController fetchSuggestObjectsFromResponseDictionary:responseObject];
		}];
}

// api.steelhoss.xyz/taksa/api/1.0/route/calculate?points[]=1,2
- (RACSignal *)fetchTaxiResultsFromObject:(TKSSuggestObject *)suggestFrom
								 toObject:(TKSSuggestObject *)suggestTo
								 regionId:(NSString *)regionId
{
	NSCParameterAssert(suggestFrom);
	NSCParameterAssert(suggestFrom);

	NSString *q = [NSString stringWithFormat:@"%@,%@", suggestFrom.id, suggestTo.id];
	NSDictionary *params = @{
		@"region_id" : regionId,
		@"points[]" : q,
	};

	return [[self GET:@"route/calculate" params:params]
		map:^NSArray<TKSTaxiSection *> *(NSDictionary *responseObject) {
			return [NSArray tks_sectionsWithDictionary:responseObject];
		}];
}

@end
