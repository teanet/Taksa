#import "TKSBaseVC.h"
#import "TKSOrderVM.h"

#import "TKSHistoryListVC.h"

@class TKSInputView;

@interface TKSOrderVC : TKSBaseVC<TKSOrderVM *>

@property (nonatomic, strong, readonly) TKSInputView *inputView;
@property (nonatomic, strong, readonly) TKSHistoryListVC *historyListVC;

@end
