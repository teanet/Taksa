#import "TKSSearchVM.h"

@interface TKSTextField : UITextField

@property (nonatomic, strong, readonly) TKSSearchVM *searchVM;

- (instancetype)initWithVM:(TKSSearchVM *)searchVM;

@end
