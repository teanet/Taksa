#import "TKSSuggest.h"

@interface TKSSearchVM : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong, readonly) NSArray<TKSSuggest *> *suggests;

@end
