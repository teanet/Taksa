#import "TKSSuggest.h"

@interface TKSSuggestListModel : NSObject
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSArray<TKSSuggest *> *suggests;

- (void)registerTableView:(UITableView *)tableView;

@end
