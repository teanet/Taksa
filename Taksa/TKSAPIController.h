@interface TKSAPIController : NSObject

- (instancetype)init;

/*! \return NSDictionary */
- (RACSignal *)GET:(NSString *)method params:(NSDictionary *)params;

@end
