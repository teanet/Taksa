#import "TKSTaxiListVM.h"

#import "TKSTaxiSection.h"
#import "TKSTaxiSuggestCell.h"
#import "TKSTaxiDefaultCell.h"
#import "UIFont+DGSCustomFont.h"
#import "UIColor+DGSCustomColor.h"
#import "TKSTaxiHeaderView.h"

@implementation TKSTaxiListVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_didSelectTaxiSignal = [[self rac_signalForSelector:@checkselector(self, didSelectTaxiRow:)]
		map:^TKSTaxiRow *(RACTuple *tuple) {
			return tuple.first;
		}];

	return self;
}

- (void)registerTableView:(UITableView *)tableView
{
	[tableView registerClass:[TKSTaxiSuggestCell class] forCellReuseIdentifier:@"cell"];
	[tableView registerClass:[TKSTaxiDefaultCell class] forCellReuseIdentifier:@"defaultCell"];
	[tableView registerClass:[TKSTaxiHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];

	tableView.rowHeight = UITableViewAutomaticDimension;
	tableView.estimatedRowHeight = 80.0;
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
	return section == 0 ? 0.0 : 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	TKSTaxiHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
	header.viewModel = self.data[section];
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TKSTaxiSuggestCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.section == 0 ? @"cell" : @"defaultCell"];
//	cell.taxiRow = self.data[indexPath.section].rows[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	[self didSelectTaxiRow:self.data[indexPath.section].rows[indexPath.row]];
}

- (void)didSelectTaxiRow:(TKSTaxiRow *)taxiRow
{
}

@end
