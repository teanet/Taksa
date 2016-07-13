#import "TKSInputVM.h"

#import "TKSSuggestListVM.h"
#import "TKSTaxiListVM.h"

@interface TKSOrderVM : NSObject

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;
@property (nonatomic, strong, readonly) TKSSuggestListVM *suggestListVM;
@property (nonatomic, strong, readonly) TKSTaxiListVM *taxiListVM;

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM;

- (void)registerTaxiTableView:(UITableView *)tableView;
- (void)registerSuggestTableView:(UITableView *)tableView;

/*! \sendNext @[TKSTaxiSection] */
- (RACSignal *)fetchTaxiList;

@end
