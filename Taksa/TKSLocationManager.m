#import "TKSLocationManager.h"

@interface TKSLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong, readonly) RACReplaySubject *locationSubject;
@property (nonatomic, strong, readonly) RACReplaySubject *authorizationStatusSubject;
@property (nonatomic, copy, readwrite) CLLocation *location;

@end

static BOOL statusIsValidForLocationReqest(CLAuthorizationStatus status)
{
	return (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways);
}

static BOOL statusIsValidForUserChoiceAboutLocation(CLAuthorizationStatus status)
{
	return status != kCLAuthorizationStatusNotDetermined;
}

@implementation TKSLocationManager

@synthesize locationManager = _locationManager;

- (instancetype)init
{
	self = [super init];
	if (!self) return nil;

	@weakify(self);

	_locationSubject = [RACReplaySubject replaySubjectWithCapacity:1];
	_locationSignal = _locationSubject;

	_authorizationStatusSubject = [RACReplaySubject replaySubjectWithCapacity:1];
	_didRecieveUserChoiceAboutLocationSignal = [[_authorizationStatusSubject
		filter:^BOOL(NSNumber *authStatus) {
			return statusIsValidForUserChoiceAboutLocation((CLAuthorizationStatus)authStatus.integerValue);
		}]
		take:1];

	// Handle case when user launched app and didn't make choice about allowing location
	// Then turned off the phone and launched it again
	// Standard UIAlertView has gone, we need to request access again
	[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification
															object:nil]
		takeUntil:self.didRecieveUserChoiceAboutLocationSignal]
		subscribeNext:^(id _) {
			@strongify(self);

			[self requestAuthorization];
		}];

	// перезапрашиваем позицию когда мы получаем разрешение на использование геолокации
	[[_authorizationStatusSubject
		filter:^BOOL(NSNumber *authStatus) {
			return statusIsValidForLocationReqest((CLAuthorizationStatus)authStatus.intValue);
		}]
		subscribeNext:^(id _) {
			@strongify(self);

			[self.locationManager startUpdatingLocation];
		}];

	return self;
}

- (void)start
{
	[self requestAuthorization];
}

- (CLLocationManager *)locationManager
{
	if (_locationManager == nil)
	{
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.activityType = CLActivityTypeFitness;
		_locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
		_locationManager.pausesLocationUpdatesAutomatically = YES;
		_locationManager.delegate = self;
		_location = _locationManager.location;
	}
	return _locationManager;
}

- (void)dealloc
{
	_locationManager.delegate = nil;
	[_locationSubject sendCompleted];
	[_authorizationStatusSubject sendCompleted];
}

- (void)requestAuthorization
{
	[self.locationManager requestWhenInUseAuthorization];
}

// MARK - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	[self.authorizationStatusSubject sendNext:@(status)];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	// Just do some Apple recommended instructions: https://developer.apple.com/library/ios/samplecode/LocateMe/Listings/LocateMe_GetLocationViewController_m.html#//apple_ref/doc/uid/DTS40007801-LocateMe_GetLocationViewController_m-DontLinkElementID_9

	CLLocation *newLocation = locations.lastObject;
	if (newLocation.horizontalAccuracy < 0) return;

	// We don't care about precise location age in this case
	NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
	if (locationAge > 100.0) return;

	self.location = newLocation;
	[self.locationSubject sendNext:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if (error.code == kCLErrorLocationUnknown) return;

	[self.locationSubject sendError:error];
}

@end
