#import "TKSAPIController+TKSModels.h"

#import "TKSAPIController+Private.h"

static NSString *const kTKS2GISWebAPIKey = @"ruczoy1743";

@implementation TKSAPIController (TKSModels)

- (RACSignal *)suggestsForString:(NSString *)searchString
{
	if (searchString.length == 0) return [RACSignal return:nil];

	NSDictionary *params = @{
		@"key": kTKS2GISWebAPIKey,
		@"type": @"default",//@"street",
		@"region_id" : @"1",
		@"lang" : @"ru",
		@"output" : @"json",
		@"types" : @"adm_div.settlement,adm_div.city,address,street,branch",
		@"q": searchString,
	};

	return [[self GET:@"suggest/list" server:TKSServiceWebAPI params:params]
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

- (RACSignal *)objectForObjectId:(NSString *)objectId
{
	NSCParameterAssert(objectId);
	if (objectId.length == 0) return [RACSignal return:nil];

	NSDictionary *params = @{
		@"key": kTKS2GISWebAPIKey,
		@"id": objectId,
		@"region_id" : @"1",
		@"lang" : @"ru",
		@"output" : @"json",
		@"fields": @"items.geometry.selection",
	};

	return [[self GET:@"geo/get" server:TKSServiceWebAPI params:params]
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

- (RACSignal *)objectForLocation:(CLLocation *)location
{
	NSCParameterAssert(location);
	if (!location) return [RACSignal return:nil];

	NSString *pointString = [NSString stringWithFormat:@"%f,%f",
		location.coordinate.longitude, location.coordinate.latitude];
	NSDictionary *params = @{
		@"key": kTKS2GISWebAPIKey,
		@"region_id" : @"1",
		@"lang" : @"ru",
		@"output" : @"json",
		@"point" : pointString,
		@"type" : @"street,building",
		@"radius" : @"1",
		@"fields": @"items.geometry.selection",
	};

	return [[self GET:@"geo/search" server:TKSServiceWebAPI params:params]
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

- (RACSignal *)objectForSearchString:(NSString *)searchString
{
	if (searchString.length == 0) return [RACSignal return:nil];

	NSDictionary *params = @{
		@"key": kTKS2GISWebAPIKey,
		@"region_id" : @"1",
		@"lang" : @"ru",
		@"output" : @"json",
		@"q" : searchString,
		@"type" : @"street,building",
		@"fields": @"items.geometry.selection",
	};

	return [[self GET:@"geo/search" server:TKSServiceWebAPI params:params]
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

- (RACSignal *)taxiListFromObject:(TKSDatabaseObject *)objectFrom
						 toObject:(TKSDatabaseObject *)objectTo
{
	return [RACSignal return:@[[TKSTaxiGroupModel testGroupeSuggest], [TKSTaxiGroupModel testGroupeList]]];
}

@end
