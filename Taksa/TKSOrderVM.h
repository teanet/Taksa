#import "TKSSuggestListModel.h"

@interface TKSOrderVM : NSObject

@property (nonatomic, strong, readonly) TKSSuggestListModel *suggestListModel;

- (void)registerTaxiTableView:(UITableView *)tableView;
- (void)registerSuggestTableView:(UITableView *)tableView;

- (void)loadDataWithCompletion:(dispatch_block_t)block;

@end
