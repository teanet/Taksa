#import "TKSSelectCityVC.h"

#import "TKSDataProvider.h"

@interface TKSSelectCityVC ()

@property (nonatomic, strong) NSArray<TKSRegion *> *regions;

@end

@implementation TKSSelectCityVC

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	[self setupReactiveStuff];

	return self;
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[[[TKSDataProvider sharedProvider] fetchRegions]
		subscribeNext:^(NSArray<TKSRegion *> *regions) {
			@strongify(self);

			self.regions = regions;
		}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	@weakify(self);

	self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.tableView.tableFooterView = [UIView new];
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 80.0;
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	UIEdgeInsets tableSeparatorInsets = UIEdgeInsetsMake(0.f, 16.f, 0.f, 16.f);
	[self.tableView setSeparatorInset:tableSeparatorInsets];
	[self.tableView setLayoutMargins:tableSeparatorInsets];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

	[RACObserve(self, regions)
		subscribeNext:^(id _) {
			@strongify(self);

			[self.tableView reloadData];
		}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.regions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	TKSRegion *region = self.regions[indexPath.row];
	cell.textLabel.text = region.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	[TKSDataProvider sharedProvider].currentRegion = self.regions[indexPath.row];
}

@end
