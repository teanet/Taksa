#import "TKSBaseVC.h"

#import "SLRTableView.h"
#import "TKSSearchTaxiVM.h"

@interface TKSSearchTaxiVC : TKSBaseVC <TKSSearchTaxiVM *>

@property (nonatomic, strong, readonly) SLRTableView *tableView;

@end
