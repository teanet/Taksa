#import "TKSInputVM.h"

#import "TKSSuggestListModel.h"

@interface TKSOrderVM : NSObject

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;
@property (nonatomic, strong, readonly) TKSSuggestListModel *suggestListModel;

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM;

- (void)registerTaxiTableView:(UITableView *)tableView;
- (void)registerSuggestTableView:(UITableView *)tableView;

- (void)loadDataWithCompletion:(dispatch_block_t)block;

/*! \sendNext @[TKSTaxiSection] */
- (RACSignal *)searchTaxiSignal;

@end
