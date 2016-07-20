@class TKSTextField;

#import "TKSInputVM.h"

@interface TKSInputView : UIControl

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;

- (instancetype)initWithVM:(TKSInputVM *)inputVM;

@end
