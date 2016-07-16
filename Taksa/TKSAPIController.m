#import "TKSAPIController.h"

#import <AFNetworking/AFNetworking.h>
#import <UIDevice-Hardware.h>

#define CURRENT_VERSION ([[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define CURRENT_BUILD ([[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey])

static NSString *const kTKSTaksaBaseURLString = @"http://api.steelhoss.xyz/taksa/api/1.0/";

@interface TKSAPIController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

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

	return self;
}

// MARK: TKSAPIController+Private
- (RACSignal *)GET:(NSString *)method params:(NSDictionary *)params
{
	@weakify(self);
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);

		id successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"<TKSAPIController> Request did successfully complete: %@", operation.request);

			[subscriber sendNext:responseObject];
			[subscriber sendCompleted];
		};

		id failBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
			@strongify(self);

			NSLog(@"<TKSAPIController> REQUEST ERROR: %@", error);
			[self didOccurError:error];
			[subscriber sendError:error];
		};

		AFHTTPRequestOperation *operation = [self.requestManager GET:method parameters:params success:successBlock failure:failBlock];

		return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
	}];
}

- (RACSignal *)POST:(NSString *)method params:(NSDictionary *)params
{
	@weakify(self);

	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);

		id successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"<NZBServerController> Request did successfully complete: %@", operation.request);

			[subscriber sendNext:responseObject];
			[subscriber sendCompleted];
		};

		id failBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
			@strongify(self);
			NSLog(@"<NZBServerController> REQUEST ERROR: %@", error);

			[self didOccurError:error];
			[subscriber sendError:error];
		};

		AFHTTPRequestOperation *op = [self.requestManager POST:method parameters:params success:successBlock failure:failBlock];
		return [RACDisposable disposableWithBlock:^{
			[op cancel];
		}];
	}];
}

- (void)didOccurError:(NSError *)error
{
}

@end
