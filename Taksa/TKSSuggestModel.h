#import "TKSSuggest.h"

@interface TKSSuggestModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong, readonly) NSArray<TKSSuggest *> *suggests;

@end
