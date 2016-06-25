#import "TKSSuggestObject.h"

@interface TKSSearchVM : NSObject

@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, copy) NSString *letter;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, strong) TKSSuggestObject *dbObject;

@property (nonatomic, strong, readonly) NSArray<TKSSuggestObject *> *suggests;

- (void)clearSuggestsAndResults;

@end
