#import "TKSInputVM.h"

#import "TKSSuggestListModel.h"

@interface TKSOrderVM : NSObject

@property (nonatomic, strong) TKSInputVM *inputVM;
@property (nonatomic, strong, readonly) TKSSuggestListModel *suggestListModel;

- (void)registerTaxiTableView:(UITableView *)tableView;
- (void)registerSuggestTableView:(UITableView *)tableView;

- (void)loadDataWithCompletion:(dispatch_block_t)block;

@end
