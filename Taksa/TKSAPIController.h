typedef NS_ENUM(NSUInteger, TKSService) {
	TKSServiceWebAPI = 0,
	TKSServiceDropbox = 1,
};

@interface TKSAPIController : NSObject

@property (nonatomic, copy, readonly) NSString *webAPIKey;
@property (nonatomic, copy, readonly) NSString *taxiProvidersFileName;

- (instancetype)initWithWebAPIKey:(NSString *)webAPIKey
			taxiProvidersFileName:(NSString *)taxiProvidersFileName NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/*! \return NSDictionary */
- (RACSignal *)GET:(NSString *)method service:(TKSService)service params:(NSDictionary *)params;

@end
