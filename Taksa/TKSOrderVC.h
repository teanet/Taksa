#import "TKSBaseVC.h"
#import "TKSOrderVM.h"
@class TKSInputView;

@interface TKSOrderVC : TKSBaseVC<TKSOrderVM *>

@property (nonatomic, strong, readonly) TKSInputView *inputView;

@end
