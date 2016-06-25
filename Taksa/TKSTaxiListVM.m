#import "TKSTaxiListVM.h"

#import "TKSTaxiSection.h"
#import "TKSTaxiSuggestCell.h"
#import "TKSTaxiDefaultCell.h"
#import "UIFont+DGSCustomFont.h"

@implementation TKSTaxiListVM

- (void)registerTableView:(UITableView *)tableView
{
	[tableView registerClass:[TKSTaxiSuggestCell class] forCellReuseIdentifier:@"cell"];
	[tableView registerClass:[TKSTaxiDefaultCell class] forCellReuseIdentifier:@"defaultCell"];

//	[tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
	tableView.rowHeight = UITableViewAutomaticDimension;
	tableView.estimatedRowHeight = 80.0;
	[tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
	tableView.delegate = self;
	tableView.dataSource = self;

	[[RACObserve(self, data)
		ignore:nil]
		subscribeNext:^(id _) {
			[tableView reloadData];
		}];
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.data[section].rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
	header.textLabel.text = self.data[section].title;
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TKSTaxiSuggestCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.section == 0 ? @"cell" : @"defaultCell"];
	cell.taxiRow = self.data[indexPath.section].rows[indexPath.row];
	return cell;
}

@end
