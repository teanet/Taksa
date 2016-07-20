 #import "TKSOrderVC.h"

#import "TKSSuggestListVC.h"
#import "TKSHistoryListVC.h"
#import "TKSInputView.h"
#import "TKSOrderVM.h"
#import "UIColor+DGSCustomColor.h"
#import "UIViewController+DGSAdditions.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

@interface TKSOrderVC ()

@property (nonatomic, strong, readonly) TKSSuggestListVC *suggestListVC;
@property (nonatomic, strong, readonly) TKSHistoryListVC *historyListVC;
@property (nonatomic, strong, readonly) UITableView *taxiTableView;

@property (nonatomic, strong, readonly) DGActivityIndicatorView *spinner;

@end

@implementation TKSOrderVC

- (instancetype)initWithVM:(id)orderVM
{
	self = [super initWithVM:orderVM];
	if (self == nil) return nil;

	_suggestListVC = [[TKSSuggestListVC alloc] initWithVM:self.viewModel.suggestListVM];
	_historyListVC = [[TKSHistoryListVC alloc] initWithVM:self.viewModel.historyListVM];

	return self;
}

- (void)loadView
{
	_spinner = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator
												   tintColor:[UIColor dgs_colorWithString:@"FFE400"]
														size:50.0];

	_taxiTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_taxiTableView.backgroundColor = [UIColor clearColor];
	_taxiTableView.showsVerticalScrollIndicator = NO;
	_taxiTableView.tableFooterView = [[UIView alloc] init];

	self.view = [[UIView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor dgs_colorWithString:@"F4F4F4"];
	[self setEdgesForExtendedLayout:UIRectEdgeNone];

	[self.viewModel registerTaxiTableView:self.taxiTableView];

	UILabel *nameLabel = [[UILabel alloc] init];
	nameLabel.text = @"ТАКСА";
	nameLabel.textColor = [UIColor dgs_colorWithString:@"333333"];
	nameLabel.font = [UIFont boldSystemFontOfSize:20];
	[nameLabel sizeToFit];
	self.navigationItem.titleView = nameLabel;

	UIView *statusBarView = [[UIView alloc] init];
	statusBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:statusBarView];

	[statusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view);
		make.leading.equalTo(self.view);
		make.trailing.equalTo(self.view);
		make.height.equalTo(@20.0);
	}];
	
	_inputView = [[TKSInputView alloc] initWithVM:self.viewModel.inputVM];
	[self.view addSubview:_inputView];
	[_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(statusBarView.mas_bottom);
		make.leading.equalTo(self.view);
		make.trailing.equalTo(self.view);
	}];

	[self dgs_showViewController:self.suggestListVC inView:self.view constraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_inputView.mas_bottom);
		make.centerX.equalTo(self.view);
		make.width.equalTo(self.view).with.offset(-32.0);
		make.bottom.equalTo(self.view);
	}];

	[self dgs_showViewController:self.historyListVC inView:self.view constraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.suggestListVC.view);
	}];

	[self.spinner startAnimating];
	[self.view addSubview:self.spinner];
	[self.spinner mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.top.equalTo(self.inputView.mas_bottom).with.offset(50.0);
	}];

	[self.view addSubview:self.taxiTableView];
	[self.taxiTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.suggestListVC.view);
	}];

	[self setupReactiveStuff];
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[[RACObserve(self.viewModel.inputVM, currentSearchVM.suggests)
		deliverOnMainThread]
		subscribeNext:^(NSArray<TKSSuggest *> *suggests) {
			@strongify(self);

			self.viewModel.suggestListVM.suggests = suggests;

			TKSOrderMode mode = (suggests.count > 0) ? TKSOrderModeSuggest : TKSOrderModeHistory;
			[self setOrderMode:mode];
		}];

	[[[[RACObserve(self.viewModel, orderMode)
		startWith:@(TKSOrderModeUndefined)]
		distinctUntilChanged]
		deliverOnMainThread]
		subscribeNext:^(NSNumber *orderModeNumber) {
			@strongify(self);

			[self setOrderMode:orderModeNumber.integerValue];
		}];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)setOrderMode:(TKSOrderMode)orderMode
{
	[UIView animateWithDuration:0.3 animations:^{
		self.taxiTableView.alpha = (orderMode != TKSOrderModeTaxiList) ? 0.0 : 1.0;
		self.suggestListVC.view.alpha = (orderMode != TKSOrderModeSuggest) ? 0.0 : 1.0;
		self.historyListVC.view.alpha = (orderMode != TKSOrderModeHistory) ? 0.0 : 1.0;
		self.spinner.alpha = (orderMode != TKSOrderModeLoading) ? 0.0 : 1.0;
	} completion:^(BOOL finished) {
		self.taxiTableView.hidden = (orderMode != TKSOrderModeTaxiList);
		self.suggestListVC.view.hidden = (orderMode != TKSOrderModeSuggest);
		self.historyListVC.view.hidden = (orderMode != TKSOrderModeHistory);
		self.spinner.hidden = (orderMode != TKSOrderModeLoading);
	}];

	if (orderMode == TKSOrderModeTaxiList)
	{
		[self.view endEditing:YES];
	}
}

@end
