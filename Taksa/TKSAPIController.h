@interface TKSAPIController : NSObject

/*! \return NSDictionary */
- (RACSignal *)GET:(NSString *)method params:(NSDictionary *)params;

@end
