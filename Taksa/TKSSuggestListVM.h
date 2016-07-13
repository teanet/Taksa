#import "TKSSuggest.h"

@interface TKSSuggestListVM : NSObject
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) RACSignal *didSelectSuggestSignal;
@property (nonatomic, strong) NSArray<TKSSuggest *> *suggests;

- (void)registerTableView:(UITableView *)tableView;

@end
