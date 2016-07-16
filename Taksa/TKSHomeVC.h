#import "TKSBaseVC.h"
#import "TKSHomeVM.h"

@class TKSInputView;

@interface TKSHomeVC : TKSBaseVC<TKSHomeVM *>

@property (nonatomic, strong, readonly) TKSInputView *inputView;

@end
