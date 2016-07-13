#import "TKSSuggestListVM.h"

#import "TKSSuggestCell.h"

@interface TKSSuggestListVM ()
<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate
>

@property (nonatomic, strong, readonly) RACSubject *didSelectSuggestSubject;

@end

@implementation TKSSuggestListVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_didSelectSuggestSubject = [RACSubject subject];
	_didSelectSuggestSignal = _didSelectSuggestSubject;

	_didScrollSignal = [self rac_signalForSelector:@checkselector(self, scrollViewDidScroll:)];

	return self;
}

- (void)dealloc
{
	[_didSelectSuggestSubject sendCompleted];
}

- (void)registerTableView:(UITableView *)tableView
{
	[tableView registerClass:[TKSSuggestCell class] forCellReuseIdentifier:@"cell"];
	tableView.delegate = self;
	tableView.dataSource = self;

	[[[[RACObserve(self, suggests)
		ignore:nil]
		takeUntil:[tableView rac_willDeallocSignal]]
		deliverOnMainThread]
		subscribeNext:^(id _) {
			[tableView reloadData];
		}];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

@end
