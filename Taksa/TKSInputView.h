@class TKSTextField;

#import "TKSInputVM.h"

@interface TKSInputView : UIControl

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;
@property (nonatomic, strong, readonly) TKSTextField *fromTF;
@property (nonatomic, strong, readonly) TKSTextField *toTF;

- (instancetype)initWithViewModel:(TKSInputVM *)inputVM;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
