#import "TKSInputVM.h"

#import "TKSSuggestListModel.h"

@interface TKSOrderVM : NSObject

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;
@property (nonatomic, strong, readonly) TKSSuggestListModel *suggestListModel;

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM;

- (void)registerTaxiTableView:(UITableView *)tableView;
- (void)registerSuggestTableView:(UITableView *)tableView;

/*! \sendNext @[TKSTaxiSection] */
- (RACSignal *)searchTaxiSignal;

@end
