#import "TKSSuggestListModel.h"

#import <DGSAttributedStringSuite/DGSAttributedStringSuite.h>
#import "UIFont+DGSCustomFont.h"

@interface TKSSuggestListModel ()

@property (nonatomic, strong, readonly) RACSubject *didSelectSuggestSubject;
@property (nonatomic, strong, readonly) RACSubject *didSelectResultSubject;

@end

@implementation TKSSuggestListModel

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_didSelectResultSubject = [RACSubject subject];
	_didSelectResultSignal = _didSelectResultSubject;
	_didSelectSuggestSubject = [RACSubject subject];
	_didSelectSuggestSignal = _didSelectSuggestSubject;

	return self;
}

- (void)dealloc
{
	[_didSelectSuggestSubject sendCompleted];
	[_didSelectResultSubject sendCompleted];
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
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSUInteger count = (section == 0)
		? self.suggests.count
		: self.results.count;
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.textLabel.numberOfLines = 0;

	if (indexPath.section == 0)
	{
		cell.textLabel.attributedText = self.suggests[indexPath.row].attributedText;
	}
	else
	{
		TKSDatabaseObject *dbObject = self.results[indexPath.row];
		cell.textLabel.attributedText = [NSAttributedString	dgs_makeString:^(DGSAttributedStringMaker *add) {
			add.string(dbObject.fullName).with.font([UIFont dgs_boldFontOfSize:15.0]);
		}];
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (indexPath.section == 0)
	{
		[self.didSelectSuggestSubject sendNext:self.suggests[indexPath.row]];
	}
	else
	{
		[self.didSelectResultSubject sendNext:self.results[indexPath.row]];
	}
}

@end
