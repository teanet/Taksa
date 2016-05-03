#import "TKSBaseVC.h"
#import "TKSRootVM.h"

@class TKSInputView;

@interface TKSRootVC : TKSBaseVC<TKSRootVM *>

@property (nonatomic, strong, readonly) TKSInputView *inputView;

@end
