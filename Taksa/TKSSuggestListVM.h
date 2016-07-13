#import "TKSSuggest.h"

@interface TKSSuggestListVM : NSObject

@property (nonatomic, strong, readonly) RACSignal *didSelectSuggestSignal;
@property (nonatomic, strong) NSArray<TKSSuggest *> *suggests;

- (void)registerTableView:(UITableView *)tableView;

@end
