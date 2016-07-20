#import "TKSSearchVM.h"

@interface TKSInputVM : NSObject

@property (nonatomic, weak) TKSSearchVM *currentSearchVM;
@property (nonatomic, strong, readonly) TKSSearchVM *fromSearchVM;
@property (nonatomic, strong, readonly) TKSSearchVM *toSearchVM;

@property (nonatomic, strong, readonly) RACSignal *didBecomeEditingSignal;
@property (nonatomic, strong, readonly) RACSignal *didPressReturnButtonSignal;

- (void)shouldStartSearchByReturn;

@end
