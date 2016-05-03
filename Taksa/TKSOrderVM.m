#import "TKSOrderVM.h"

#import "TKSTaxiListVM.h"
#import "TKSTaxiSection.h"

@interface TKSOrderVM ()

@property (nonatomic, strong, readonly) TKSTaxiListVM *taxiListVM;

@end

@implementation TKSOrderVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_taxiListVM = [[TKSTaxiListVM alloc] init];
	_suggestListModel = [[TKSSuggestListModel alloc] init];
	_inputVM = [[TKSInputVM alloc] init];

	return self;
}

- (void)registerTaxiTableView:(UITableView *)tableView
{
	[self.taxiListVM registerTableView:tableView];
}

- (void)registerSuggestTableView:(UITableView *)tableView
{
	[self.suggestListModel registerTableView:tableView];
}

- (void)loadDataWithCompletion:(dispatch_block_t)block
{
	@weakify(self);
	[[[RACSignal return:nil]
		delay:1.0]
		subscribeNext:^(id _) {
			@strongify(self);

			self.taxiListVM.data = @[
				[TKSTaxiSection testGroupeSuggest],
				[TKSTaxiSection testGroupeList],
			];

			block();
		}];
}

@end
