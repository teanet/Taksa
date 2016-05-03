#import "TKSRegion.h"

@interface TKSSelectCityVM : NSObject
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSArray<TKSRegion *> *regions;
@property (nonatomic, strong, readonly) RACSignal *didSelectRegionSignal;
@property (nonatomic, strong, readonly) RACSignal *didCloseSignal;

- (void)registerTableView:(UITableView *)tableView;
- (void)close;

@end
