#import "TKSHistoryListVM.h"

#import "TKSHistoryCell.h"
#import "TKSDataProvider.h"

@interface TKSHistoryListVM ()
<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate
>

@property (nonatomic, strong, readonly) RACSubject *didSelectSuggestSubject;

@end

@implementation TKSHistoryListVM

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
	[tableView registerClass:[TKSHistoryCell class] forCellReuseIdentifier:@"cell"];
	tableView.delegate = self;
	tableView.dataSource = self;

	[[[[RACObserve(self, suggests)
		ignore:nil]
		takeUntil:[tableView rac_willDeallocSignal]]
		deliverOnMainThread]
		subscribeNext:^(id _) {
			[tableView reloadData];
		}];

	[self loadHistory];
}

- (void)loadHistory
{
	self.suggests = [TKSDataProvider sharedProvider].historyList;
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
	TKSSuggest *suggest = [self.suggests objectAtIndex:indexPath.row];
	TKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.viewModel = suggest;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	[self.didSelectSuggestSubject sendNext:self.suggests[indexPath.row]];
}

@end
