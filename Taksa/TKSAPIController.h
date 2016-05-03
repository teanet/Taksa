typedef NS_ENUM(NSUInteger, TKSService) {
	TKSServiceWebAPI = 0,
};

@interface TKSAPIController : NSObject

@property (nonatomic, copy, readonly) NSString *webAPIKey;

- (instancetype)initWithWebAPIKey:(NSString *)webAPIKey NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

/*! \return NSDictionary */
- (RACSignal *)GET:(NSString *)method service:(TKSService)service params:(NSDictionary *)params;

@end
