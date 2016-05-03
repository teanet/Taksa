#import "TKSAPIController.h"

#import <AFNetworking/AFNetworking.h>

static NSString *const kTKS2GISWebAPIBaseURLString = @"http://catalog.api.2gis.ru/2.0/";

@interface TKSAPIController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManagerWebApi;

@end

@implementation TKSAPIController

- (instancetype)initWithWebAPIKey:(NSString *)webAPIKey
{
	self = [super init];
	if (self == nil) return nil;

	_webAPIKey = [webAPIKey copy];
	_requestManagerWebApi = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kTKS2GISWebAPIBaseURLString]];
	_requestManagerWebApi.requestSerializer = [AFJSONRequestSerializer serializer];
	_requestManagerWebApi.requestSerializer.timeoutInterval = 10.0;
	_requestManagerWebApi.responseSerializer = [AFJSONResponseSerializer serializer];

	return self;
}


// MARK: TKSAPIController+Private
- (RACSignal *)GET:(NSString *)method service:(TKSService)service params:(NSDictionary *)params
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

		AFHTTPRequestOperationManager *requestManager = [self requestManagerForService:service];
		AFHTTPRequestOperation *operation = [requestManager GET:method parameters:params success:successBlock failure:failBlock];

		return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
	}];
}

- (AFHTTPRequestOperationManager *)requestManagerForService:(TKSService)service
{
	switch (service)
	{
		case TKSServiceWebAPI : return self.requestManagerWebApi;
	}

	return nil;
}

@end
