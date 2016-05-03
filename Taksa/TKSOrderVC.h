@class TKSInputView, TKSOrderVM;

@interface TKSOrderVC : UIViewController

@property (nonatomic, strong, readonly) TKSInputView *inputView;

- (instancetype)initWithVM:(TKSOrderVM *)orderVM;

@end
