#import "TKSBaseVM.h"

#import "TKSInputVM.h"

@interface TKSSearchTaxiVM : TKSBaseVM

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM;

- (void)registerTableView:(UITableView *)tableView;

@end
