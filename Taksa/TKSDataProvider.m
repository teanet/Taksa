#import "TKSDataProvider.h"

#import "TKSAPIController+TKSModels.h"
#import "TKSLocationManager.h"
#import "TKSTaxiManager.h"
#import "TKSRoute.h"

static NSString *const kTKS2GISWebAPIKey = @"ruczoy1743";
static NSString *const kTaxiProvidersName = @"taxiProviders.json";

@interface TKSDataProvider ()

@property (nonatomic, strong, readonly) TKSAPIController *apiController;
@property (nonatomic, strong, readonly) TKSLocationManager *locationManager;
@property (nonatomic, strong, readonly) TKSTaxiManager *taxiManager;

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

	_apiController = [[TKSAPIController alloc] initWithWebAPIKey:kTKS2GISWebAPIKey taxiProvidersFileName:kTaxiProvidersName];
	_locationManager = [[TKSLocationManager alloc] init];
	_taxiManager = [[TKSTaxiManager alloc] init];

	[self loadTaxiesFromLocalStorage];
	[self updateTaxiesFromRemoteServer];

	return self;
}

- (void)updateTaxiesFromRemoteServer
{
	[[self.apiController fetchTaxiDictionariesArray]
		subscribeNext:^(NSArray *taxiDictionariesArray) {
			NSData *fileData = [NSKeyedArchiver archivedDataWithRootObject:taxiDictionariesArray];
			NSString *path = [[NSBundle mainBundle] pathForResource:kTaxiProvidersName ofType:nil];

			if (path.length > 0)
			{
				NSURL *pathURL = [NSURL URLWithString:path];
				[fileData writeToURL:pathURL atomically:YES];
			}

			[self loadTaxiesWithTaxiDictionariesArray:taxiDictionariesArray];
		}];
}

- (void)loadTaxiesFromLocalStorage
{
	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kTaxiProvidersName ofType:nil]];
	if (data.length > 0)
	{
		NSArray *taxiDictionariesArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		[self loadTaxiesWithTaxiDictionariesArray:taxiDictionariesArray];
	}
}

- (void)loadTaxiesWithTaxiDictionariesArray:(NSArray<NSDictionary *> *)taxiDictionariesArray
{
	NSArray<TKSTaxi *> *taxies = [taxiDictionariesArray.rac_sequence
		map:^TKSTaxi *(NSDictionary *taxiDictionary) {
			return [[TKSTaxi alloc] initWithDictionary:taxiDictionary];
		}].array;

	self.taxiManager.taxies = taxies;
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
	@weakify(self);

	return [[self.apiController fetchRouteFromObject:objectFrom toObject:objectTo regionId:self.currentRegion.id]
		map:^TKSTaxiSection *(TKSRoute *route) {
			@strongify(self);
			
			return @[[self.taxiManager sectionResultsForRoute:route]];
		}];
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

// MARK: LocalTaxi Data Management

@end
