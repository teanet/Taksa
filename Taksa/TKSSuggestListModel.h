#import "TKSSuggest.h"
#import "TKSDatabaseObject.h"

@interface TKSSuggestListModel : NSObject
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) RACSignal *didSelectSuggestSignal;
@property (nonatomic, strong, readonly) RACSignal *didSelectResultSignal;

@property (nonatomic, strong) NSArray<TKSSuggest *> *suggests;
@property (nonatomic, strong) NSArray<TKSDatabaseObject *> *results;

- (void)registerTableView:(UITableView *)tableView;

@end
