@class TKSTextField;

#import "TKSInputVM.h"

@interface TKSInputView : UIControl

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;
@property (nonatomic, strong, readonly) TKSTextField *fromTF;
@property (nonatomic, strong, readonly) TKSTextField *toTF;

- (instancetype)initWithVM:(TKSInputVM *)inputVM;

@end
