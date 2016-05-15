#import "TKSAPIController.h"

#import <AFNetworking/AFNetworking.h>

static NSString *const kTKS2GISWebAPIBaseURLString = @"http://catalog.api.2gis.ru/2.0/";
static NSString *const kTKSDropboxBaseURLString = @"https://dl.dropboxusercontent.com/u/39349894/Taksa/";

@interface TKSAPIController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManagerWebApi;
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManagerDropbox;

@end

@implementation TKSAPIController

- (instancetype)initWithWebAPIKey:(NSString *)webAPIKey taxiProvidersFileName:(NSString *)taxiProvidersFileName
{
	self = [super init];
	if (self == nil) return nil;

	_webAPIKey = [webAPIKey copy];
	_taxiProvidersFileName = [taxiProvidersFileName copy];
	
	_requestManagerWebApi = [TKSAPIController requestManagerWithURLString:kTKS2GISWebAPIBaseURLString];
	_requestManagerDropbox = [TKSAPIController requestManagerWithURLString:kTKSDropboxBaseURLString];

	return self;
}

+ (AFHTTPRequestOperationManager *)requestManagerWithURLString:(NSString *)urlString
{
	AFHTTPRequestOperationManager *manager =
		[[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];

	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	manager.requestSerializer.timeoutInterval = 10.0;
	manager.responseSerializer = [AFJSONResponseSerializer serializer];

	NSSet *typesSet = [NSSet setWithArray:@[@"text/plain", @"application/json"]];
	[manager.responseSerializer setAcceptableContentTypes:typesSet];

	return manager;
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
		case TKSServiceWebAPI	: return self.requestManagerWebApi;
		case TKSServiceDropbox	: return self.requestManagerDropbox;
	}

	return nil;
}

@end
