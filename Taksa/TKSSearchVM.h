#import "TKSSuggest.h"

@interface TKSSearchVM : NSObject

@property (nonatomic, assign) BOOL active;
@property (nonatomic, copy) NSString *letter;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, strong, readonly) NSArray<TKSSuggest *> *suggests;

@end
