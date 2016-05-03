#import "TKSOrderVC.h"

#import "TKSInputView.h"
#import "TKSOrderVM.h"
#import "UIColor+DGSCustomColor.h"

typedef NS_ENUM(NSUInteger, TKSOrderMode) {
	TKSOrderModeSearch = 0,
	TKSOrderModeLoading,
	TKSOrderModeTaxiList,
};

@interface TKSOrderVC ()

@property (nonatomic, strong, readonly) UITableView *suggestTableView;
@property (nonatomic, strong, readonly) UITableView *taxiTableView;

@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinner;

@property (nonatomic, assign) TKSOrderMode orderMode;

@end

@implementation TKSOrderVC

- (instancetype)initWithVM:(id)orderVM
{
	self = [super initWithVM:orderVM];
	if (self == nil) return nil;

	self.orderMode = TKSOrderModeSearch;

	return self;
}

- (void)loadView
{
	_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_suggestTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_taxiTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.view = [[UIView alloc] init];
}

- (void)viewDidLoad
{
	@weakify(self);

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
	[self setEdgesForExtendedLayout:UIRectEdgeNone];

	[self.viewModel registerTaxiTableView:self.taxiTableView];
	[self.viewModel registerSuggestTableView:self.suggestTableView];

	[[RACObserve(self.viewModel.inputVM, currentSearchVM.suggests)
		ignore:nil]
		subscribeNext:^(NSArray *suggests) {
			@strongify(self);

			self.viewModel.suggestListModel.suggests = suggests;
			[self.suggestTableView reloadData];
		}];
	[self.viewModel.inputVM.didBecomeEditingSignal subscribeNext:^(id x) {
		@strongify(self);

		self.orderMode = TKSOrderModeSearch;
	}];

	UILabel *nameLabel = [[UILabel alloc] init];
	nameLabel.text = @"ТАКСА";
	nameLabel.textColor = [UIColor dgs_colorWithString:@"333333"];
	nameLabel.font = [UIFont boldSystemFontOfSize:20];
	[nameLabel sizeToFit];
	self.navigationItem.titleView = nameLabel;
	
	_inputView = [[TKSInputView alloc] initWithVM:self.viewModel.inputVM];
	[self.view addSubview:_inputView];
	[_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.view);
		make.leading.equalTo(self.view);
		make.trailing.equalTo(self.view);
	}];

	[self.view addSubview:self.suggestTableView];
	[self.suggestTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_inputView.mas_bottom);
		make.leading.equalTo(self.view);
		make.trailing.equalTo(self.view);
		make.bottom.equalTo(self.view);
	}];

	[self.spinner startAnimating];
	[self.view addSubview:self.spinner];
	[self.spinner mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
	}];

	[self.view addSubview:self.taxiTableView];
	[self.taxiTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.suggestTableView);
	}];
}

- (void)setOrderMode:(TKSOrderMode)orderMode
{
	_orderMode = orderMode;

	self.taxiTableView.hidden = (orderMode != TKSOrderModeTaxiList);
	self.suggestTableView.hidden = (orderMode != TKSOrderModeSearch);
	self.spinner.hidden = (orderMode != TKSOrderModeLoading);

	switch (orderMode) {
		case TKSOrderModeSearch:
		{
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchTap)];
			break;
		}
		case TKSOrderModeLoading:
		{
			self.navigationItem.rightBarButtonItem = nil;
			break;
		}
		case TKSOrderModeTaxiList:
		{
			[self.view endEditing:YES];
			break;
		}
	}
}

- (void)searchTap
{
	@weakify(self);
	self.orderMode = TKSOrderModeLoading;

	[self.viewModel loadDataWithCompletion:^{
		@strongify(self);

		[self.taxiTableView reloadData];
		self.orderMode = TKSOrderModeTaxiList;
	}];
}

@end
