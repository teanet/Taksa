#import "TKSSuggestListModel.h"

#import <DGSAttributedStringSuite/DGSAttributedStringSuite.h>
#import "UIFont+DGSCustomFont.h"

@interface TKSSuggestListModel ()

@property (nonatomic, strong, readonly) RACSubject *didSelectSuggestSubject;

@end

@implementation TKSSuggestListModel

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_didSelectSuggestSubject = [RACSubject subject];
	_didSelectSuggestSignal = _didSelectSuggestSubject;

	return self;
}

- (void)dealloc
{
	[_didSelectSuggestSubject sendCompleted];
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
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.attributedText = self.suggests[indexPath.row].attributedText;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	[self.didSelectSuggestSubject sendNext:self.suggests[indexPath.row]];
}

@end
