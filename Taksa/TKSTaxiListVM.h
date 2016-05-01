@class TKSTaxiSection;

@interface TKSTaxiListVM : NSObject
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSArray<TKSTaxiSection *> *data;

- (void)registerTableView:(UITableView *)tableView;

@end
