@interface TKSBaseVC<VMClass> : UIViewController

- (instancetype)initWithVM:(VMClass)orderVM NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (VMClass)viewModel;

@end
