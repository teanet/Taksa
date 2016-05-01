#import "TKSSelectCityVC.h"

@interface TKSSelectCityVC ()

@property (nonatomic, strong, readonly) NSArray *cities;

@end

@implementation TKSSelectCityVC

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_cities = @[
		@"Новосибирск",
		@"Омск",
	];

	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.tableView.tableFooterView = [UIView new];
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 80.0;
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	UIEdgeInsets tableSeparatorInsets = UIEdgeInsetsMake(0.f, 16.f, 0.f, 16.f);
	[self.tableView setSeparatorInset:tableSeparatorInsets];
	[self.tableView setLayoutMargins:tableSeparatorInsets];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.textLabel.text = self.cities[indexPath.row];
	return cell;
}

@end
