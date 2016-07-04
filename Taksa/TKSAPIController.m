#import "TKSAPIController.h"

#import <AFNetworking/AFNetworking.h>

static NSString *const kTKSTaksaBaseURLString = @"http://api.steelhoss.xyz/taksa/api/1.0/";

@interface TKSAPIController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@end

@implementation TKSAPIController

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;
	
	_requestManager = [TKSAPIController requestManagerWithURLString:kTKSTaksaBaseURLString];

	return self;
}

+ (AFHTTPRequestOperationManager *)requestManagerWithURLString:(NSString *)urlString
{
	AFHTTPRequestOperationManager *manager =
		[[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];

	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	manager.requestSerializer.timeoutInterval = 30.0;
	manager.responseSerializer = [AFJSONResponseSerializer serializer];

	NSSet *typesSet = [NSSet setWithArray:@[@"text/plain", @"application/json"]];
	[manager.responseSerializer setAcceptableContentTypes:typesSet];

	return manager;
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
			NSLog(@"<TKSAPIController> REQUEST ERROR: %@", error);
			[subscriber sendError:error];
		};

		AFHTTPRequestOperation *operation = [self.requestManager GET:method parameters:params success:successBlock failure:failBlock];

		return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
	}];
}

@end
