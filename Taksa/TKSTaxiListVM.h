@class TKSTaxiSection;

@interface TKSTaxiListVM : NSObject
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSArray<TKSTaxiSection *> *data;
@property (nonatomic, strong, readonly) RACSignal *didSelectTaxiSignal;

- (void)registerTableView:(UITableView *)tableView;

@end
