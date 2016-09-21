#import "TKSAPIController.h"

#import <AFNetworking/AFNetworking.h>
#import <UIDevice-Hardware/UIDevice-Hardware.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#define CURRENT_VERSION ([[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define CURRENT_BUILD ([[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey])

static NSString *const kTKSTaksaBaseURLString = //@"http://taksa.steelhoss.xyz/taksa/api/1.0/";
 @"http://10.154.18.171:8080/taksa/api/1.0/"; //

@interface TKSAPIController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic, assign) NSInteger activityCounter;

@end

@implementation TKSAPIController

- (instancetype)initWithUserId:(NSString *)userId sessionId:(NSString *)sessionId
{
	NSCParameterAssert(userId);
	NSCParameterAssert(sessionId);

	self = [super init];
	if (self == nil) return nil;

	_didOccurNetworkErrorSignal = [[self rac_signalForSelector:@checkselector(self, didOccurError:)]
		map:^NSError *(RACTuple *t) {
			return t.first;
		}];
	
	_requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kTKSTaksaBaseURLString]];
	_requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
	_requestManager.requestSerializer.timeoutInterval = 30.0;

	NSDictionary *headers = @{
		@"X-Current-App-Build" : CURRENT_BUILD,
		@"X-Current-App-Version" : CURRENT_VERSION,
		@"X-Mobile-Vendor" : @"Apple",
		@"X-Mobile-Platform" : @"iOS",
		@"X-Mobile-Os-Version" : [[UIDevice currentDevice] systemVersion],
		@"X-Mobile-Model": [[UIDevice currentDevice] modelName],
		@"X-User-Session": sessionId,
		@"X-User-Id": userId,
	};

	[headers enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
		[_requestManager.requestSerializer setValue:value forHTTPHeaderField:key];
	}];

	_requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
	NSSet *typesSet = [NSSet setWithArray:@[@"text/plain", @"application/json"]];
	[_requestManager.responseSerializer setAcceptableContentTypes:typesSet];

	[_requestManager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

	[self logUserWithId:userId];

	return self;
}

- (void)logUserWithId:(NSString *)id
{
	[CrashlyticsKit setUserIdentifier:id];
}

// MARK: TKSAPIController+Private
- (RACSignal *)GET:(NSString *)method params:(NSDictionary *)params
{
	@weakify(self);

	[self incrementActivity];

	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);

		id successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"<TKSAPIController> Request did successfully complete: %@", operation.request);

			[subscriber sendNext:responseObject];
			[subscriber sendCompleted];
		};

		id failBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
			@strongify(self);

			NSLog(@"<TKSAPIController> REQUEST ERROR: %@", error);

			if (error.code != 3840)
			{
				[self didOccurError:error];
			}

			[subscriber sendError:error];
		};

		AFHTTPRequestOperation *operation = [self.requestManager GET:method parameters:params success:successBlock failure:failBlock];

		return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
	}]
	finally:^{
		[self decrementActivity];
	}];
}

- (RACSignal *)POST:(NSString *)method params:(NSDictionary *)params
{
	@weakify(self);

	[self incrementActivity];

	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);

		id successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"<NZBServerController> Request did successfully complete: %@", operation.request);

			[subscriber sendNext:responseObject];
			[subscriber sendCompleted];
		};

		id failBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
			@strongify(self);
			NSLog(@"<NZBServerController> REQUEST ERROR: %@", error);

			if (error.code != 3840)
			{
				[self didOccurError:error];
			}

			[subscriber sendError:error];
		};

		AFHTTPRequestOperation *op = [self.requestManager POST:method parameters:params success:successBlock failure:failBlock];
		return [RACDisposable disposableWithBlock:^{
			[op cancel];
		}];
	}]
	finally:^{
		@strongify(self);

		[self decrementActivity];
	}];
}

- (void)didOccurError:(NSError *)error
{
}

// User Activity

- (void)incrementActivity
{
	@synchronized (self)
	{
		self.activityCounter++;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
}

- (void)decrementActivity
{
	@synchronized (self)
	{
		self.activityCounter--;
		if (self.activityCounter <= 0)
		{
			self.activityCounter = 0;
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
	}
}

@end
