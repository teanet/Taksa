#import "TKSSuggestListModel.h"

@implementation TKSSuggestListModel

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;
	return self;
}

- (void)registerTableView:(UITableView *)tableView
{
	[tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
	[tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
	tableView.delegate = self;
	tableView.dataSource = self;
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.suggests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.textLabel.attributedText = self.suggests[indexPath.row].attributedText;
	return cell;
}

@end
