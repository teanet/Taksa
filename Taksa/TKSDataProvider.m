#import "TKSDataProvider.h"

#import "TKSAPIController+TKSModels.h"
#import "TKSLocationManager.h"
#import "TKSPreferences.h"

static NSString *const kTaxiProvidersName = @"taxiProviders.json";

@interface TKSDataProvider ()

@property (nonatomic, strong, readonly) TKSAPIController *apiController;
@property (nonatomic, strong, readonly) TKSLocationManager *locationManager;
@property (nonatomic, strong, readonly) TKSPreferences *preferences;

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

	_preferences = [[TKSPreferences alloc] init];
	NSString *userId = _preferences.userId;
	NSString *sessionId = _preferences.sessionId;
	_apiController = [[TKSAPIController alloc] initWithUserId:userId sessionId:sessionId];
	_locationManager = [[TKSLocationManager alloc] init];
	_taxiProcessor = [[TKSTaxiProcessor alloc] init];

	return self;
}

// MARK: TKSAPIController+TKSModels
- (RACSignal *)fetchSuggestsForSearchString:(NSString *)searchString
{
	return [self.apiController fetchSuggestsForSearchString:searchString
												   regionId:self.currentRegion.id];
}

- (RACSignal *)fetchSuggestForLocation
{
	@weakify(self);

	return [[[self.locationManager locationSignal]
		take:1]
		flattenMap:^RACStream *(CLLocation *location) {
			@strongify(self);

			return [self.apiController fetchSuggestForLocation:location regionId:self.currentRegion.id];
		}];
}

- (RACSignal *)fetchTaxiListFromObject:(TKSSuggest *)objectFrom
							  toObject:(TKSSuggest *)objectTo
{
	return [self.apiController fetchTaxiResultsFromObject:objectFrom toObject:objectTo regionId:self.currentRegion.id];
}

- (RACSignal *)fetchRegions
{
	return [self.apiController fetchRegions];
}

- (RACSignal *)fetchCurrentRegion
{
	@weakify(self);
	[self.locationManager start];

	return [[[[[self.locationManager.locationSignal
		ignore:nil]
		take:1]
		flattenMap:^RACStream *(CLLocation *location) {
			return [self.apiController fetchCurrentRegionWithLocation:location];
		}]
		ignore:nil]
		doNext:^(TKSRegion *region) {
			@strongify(self);

			self.currentRegion = region;
			[self sendAnalyticsForType:@"launch" body:nil];
		}];
}

- (void)sendAnalyticsForType:(NSString *)type body:(NSDictionary *_Nullable)bodyDictionary
{
	[[self.apiController fetchAnalyticsResultForType:type body:bodyDictionary regionId:self.currentRegion.id]
		subscribeNext:^(id x) {
			NSLog(@">>> %@", x);
		}];
}

- (void)addSuggestToHistory:(TKSSuggest *)suggest
{
	[self.preferences addSuggestDictionaryToHistoryList:suggest.dictionary];
}

- (NSArray<TKSSuggest *> *)historyList
{
	return [[self.preferences historyDictionaries].rac_sequence
		map:^TKSSuggest *(NSDictionary *suggestDictionary) {
			return [[TKSSuggest alloc] initWithDictionary:suggestDictionary];
		}].array;
}

- (RACSignal *)errorSignal
{
	return self.apiController.didOccurNetworkErrorSignal;
}

@end
