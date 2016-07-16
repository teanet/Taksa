#import "TKSSuggest.h"

@interface TKSSearchVM : NSObject

@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, copy) NSString *letter;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, strong) TKSSuggest *dbObject;

@property (nonatomic, strong, readonly) NSArray<TKSSuggest *> *suggests;

@end
