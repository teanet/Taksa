#import "TKSSelectCityVM.h"

#import "TKSDataProvider.h"
#import "TKSRegionCell.h"

#import <Crashlytics/Crashlytics.h>

@implementation TKSSelectCityVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;
	@weakify(self);
	
	[[[TKSDataProvider sharedProvider] fetchRegions]
		subscribeNext:^(NSArray<TKSRegion *> *regions) {
			@strongify(self);

			self.regions = regions;
		}];

	_didSelectRegionSignal = [[self rac_signalForSelector:@checkselector(self, tableView:, didSelectRowAtIndexPath:)]
		mapReplace:nil];

	_didCloseSignal = [[self rac_signalForSelector:@checkselector0(self, close)] mapReplace:nil];

	return self;
}

- (void)registerTableView:(UITableView *)tableView
{
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.tableFooterView = [UIView new];
	tableView.rowHeight = UITableViewAutomaticDimension;
	tableView.estimatedRowHeight = 80.0;
	tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	UIEdgeInsets tableSeparatorInsets = UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0);
	[tableView setSeparatorInset:tableSeparatorInsets];
	[tableView setLayoutMargins:tableSeparatorInsets];
	[tableView registerClass:[TKSRegionCell class] forCellReuseIdentifier:@"cell"];
}

- (void)close
{
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
	TKSRegionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	TKSRegion *region = self.regions[indexPath.row];
	cell.region = region;
	cell.accessoryType = [region.id isEqualToString:[TKSDataProvider sharedProvider].currentRegion.id]
		? UITableViewCellAccessoryCheckmark
		: UITableViewCellAccessoryNone;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[TKSDataProvider sharedProvider].currentRegion = self.regions[indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSDictionary *body = @{
		@"region_id" : [TKSDataProvider sharedProvider].currentRegion.id,
	};
	[[TKSDataProvider sharedProvider] sendAnalyticsForType:@"city-select" body:body];

	[Answers logContentViewWithName:@"city-select"
						contentType:[TKSDataProvider sharedProvider].currentRegion.title
						  contentId:[TKSDataProvider sharedProvider].currentRegion.id
				   customAttributes:body];
}

@end
