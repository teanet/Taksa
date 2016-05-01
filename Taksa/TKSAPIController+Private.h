#import "TKSAPIController.h"

typedef NS_ENUM(NSUInteger, TKSService) {
	TKSServiceWebAPI = 0,
};

@interface TKSAPIController (Private)

/*! \return NSDictionary */
- (RACSignal *)GET:(NSString *)method server:(TKSService)service params:(NSDictionary *)params;

@end