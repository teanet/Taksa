#import "TKSSuggestObject.h"

@interface TKSSuggestModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong, readonly) NSArray<TKSSuggestObject *> *suggests;

@end
