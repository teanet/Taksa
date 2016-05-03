#import "TKSSuggest.h"

@interface TKSSearchVM : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, strong, readonly) NSArray<TKSSuggest *> *suggests;

@end
