@interface TKSAPIController : NSObject

- (instancetype)initWithUserId:(NSString *)userId sessionId:(NSString *)sessionId NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

/*! \return NSDictionary */
- (RACSignal *)GET:(NSString *)method params:(NSDictionary *)params;

/*! \return NSDictionary */
- (RACSignal *)POST:(NSString *)method params:(NSDictionary *)params;

@end
