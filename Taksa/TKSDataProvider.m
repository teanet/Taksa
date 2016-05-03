#import "TKSDataProvider.h"

#import "TKSAPIController+TKSModels.h"
#import "TKSLocationManager.h"

static NSString *const kTKS2GISWebAPIKey = @"ruczoy1743";

@interface TKSDataProvider ()

@property (nonatomic, strong, readonly) TKSAPIController *apiController;
@property (nonatomic, strong, readonly) TKSLocationManager *locationManager;

@end

@implementation TKSDataProvider

+ (instancetype)sharedProvider
{
	static TKSDataProvider *provider = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		provider = [[TKSDataProvider alloc] init];
	});

	return provider;
}

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_apiController = [[TKSAPIController alloc] initWithWebAPIKey:kTKS2GISWebAPIKey];
	_locationManager = [[TKSLocationManager alloc] init];

	return self;
}

// MARK: TKSAPIController+TKSModels
- (RACSignal *)fetchSuggestsForSearchString:(NSString *)searchString
{
	return [self.apiController fetchSuggestsForSearchString:searchString
												   regionId:self.currentRegion.id];
}

- (RACSignal *)fetchObjectsForSearchString:(NSString *)searchString
{
	return [self.apiController fetchObjectsForSearchString:searchString
												  regionId:self.currentRegion.id];
}

- (RACSignal *)fetchObjectForObjectId:(NSString *)objectId
{
	return [self.apiController fetchObjectForObjectId:objectId
											 regionId:self.currentRegion.id];
}

- (RACSignal *)fetchObjectForLocation:(CLLocation *)location
{
	return [self.apiController fetchObjectForLocation:location
											 regionId:self.currentRegion.id];
}

- (RACSignal *)fetchTaxiListFromObject:(TKSDatabaseObject *)objectFrom
							  toObject:(TKSDatabaseObject *)objectTo
{
	return [self.apiController fetchTaxiListFromObject:objectFrom
											  toObject:objectTo];
}

- (RACSignal *)fetchRegions
{
	return [self.apiController fetchRegions];
}

- (RACSignal *)fetchCurrentRegion
{
	@weakify(self);
	[self.locationManager start];

	return [[[[self.locationManager.locationSignal
		ignore:nil]
		take:1]
		flattenMap:^RACStream *(CLLocation *location) {
			return [self.apiController fetchCurrentRegionWithLocation:location];
		}]
		doNext:^(TKSRegion *region) {
			@strongify(self);

			self.currentRegion = region;
		}];
}

@end
