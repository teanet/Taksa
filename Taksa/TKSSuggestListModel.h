#import "TKSSuggestObject.h"

@interface TKSSuggestListModel : NSObject
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) RACSignal *didSelectSuggestSignal;
@property (nonatomic, strong) NSArray<TKSSuggestObject *> *suggests;

- (void)registerTableView:(UITableView *)tableView;

@end
