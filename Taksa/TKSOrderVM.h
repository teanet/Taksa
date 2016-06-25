#import "TKSInputVM.h"

#import "TKSSuggestListModel.h"
#import "TKSTaxiListVM.h"

@interface TKSOrderVM : NSObject

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;
@property (nonatomic, strong, readonly) TKSSuggestListModel *suggestListModel;
@property (nonatomic, strong, readonly) TKSTaxiListVM *taxiListVM;

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM;

- (void)registerTaxiTableView:(UITableView *)tableView;
- (void)registerSuggestTableView:(UITableView *)tableView;

/*! \sendNext @[TKSTaxiSection] */
- (RACSignal *)fetchTaxiList;

@end
