#import "TKSSearchTaxiVC.h"

#import "UIColor+DGSCustomColor.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

@interface TKSSearchTaxiVC ()

@property (nonatomic, strong, readonly) DGActivityIndicatorView *spinner;
@property (nonatomic, assign) CGFloat carsBottomOffset;
@property (nonatomic, strong, readonly) UILabel *emptyResultsLabel;

@end

@implementation TKSSearchTaxiVC

- (void)dealloc
{
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor dgs_colorWithString:@"F4F4F4"];

	_spinner = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator
												   tintColor:[UIColor dgs_colorWithString:@"FFE400"]
														size:50.0];
	[_spinner startAnimating];
	[self.view addSubview:_spinner];

	_emptyResultsLabel = [[UILabel alloc] init];
	_emptyResultsLabel.text = @"По Вашему запросу ничего не нашлось";
	_emptyResultsLabel.hidden = YES;
	_emptyResultsLabel.textColor = [UIColor grayColor];
	_emptyResultsLabel.font = [UIFont systemFontOfSize:14.0];
	[self.view addSubview:_emptyResultsLabel];

	_tableView = [[SLRTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_tableView.tableFooterView = [[UIView alloc] init];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.showsVerticalScrollIndicator = NO;
	_tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 162.0, 0.0);
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:_tableView];

	UIView *statusBarView = [[UIView alloc] init];
	statusBarView.backgroundColor = [UIColor dgs_colorWithString:@"FFC533"];
	[self.view addSubview:statusBarView];

	UIView *grayStatusBarView = [[UIView alloc] init];
	grayStatusBarView.backgroundColor = [UIColor dgs_colorWithString:@"F4F4F4"];
	[self.view addSubview:grayStatusBarView];

	// Report Error Button

	UIColor *textColor = [UIColor dgs_colorWithString:@"CFCFCF"];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = 5.0;
	NSDictionary *textAttrs = @{
								NSForegroundColorAttributeName : textColor,
								NSParagraphStyleAttributeName : paragraphStyle
								};
	NSDictionary *mailAttrs = @{
								NSForegroundColorAttributeName : textColor,
								NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
								};

	UILabel *disclaimerLabel = [[UILabel alloc] init];
	NSString *disclaimer = @"Перед поездкой уточните цену\nу перевозчика. Такса рассчитывает\nеё по публичным тарифам на сайтах\nслужб. Для пожеланий и ошибок:";
	NSAttributedString *attDisclaimer = [[NSAttributedString alloc] initWithString:disclaimer
																		attributes:textAttrs];
	disclaimerLabel.attributedText = attDisclaimer;
	disclaimerLabel.font = [UIFont systemFontOfSize:12.0];
	disclaimerLabel.numberOfLines = 0;
	disclaimerLabel.textAlignment = NSTextAlignmentCenter;


	NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@""
																				attributes:textAttrs];
	NSAttributedString *mailStr = [[NSAttributedString alloc] initWithString:@"taxi@2gis.ru" attributes:mailAttrs];
	[attrStr appendAttributedString:mailStr];

	UIButton *reportErrorButton = [[UIButton alloc] init];
	[reportErrorButton setAttributedTitle:attrStr forState:UIControlStateNormal];
	reportErrorButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
	[reportErrorButton setTitleColor:[[UIColor dgs_colorWithString:@"333333"] colorWithAlphaComponent:0.5]
							 forState:UIControlStateNormal];
	[reportErrorButton addTarget:self.viewModel
						   action:@checkselector0(self.viewModel, reportError)
				 forControlEvents:UIControlEventTouchUpInside];
	[self.view insertSubview:reportErrorButton belowSubview:self.tableView];
	[self.view insertSubview:disclaimerLabel belowSubview:reportErrorButton];
	[reportErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@32.0);
		make.centerX.equalTo(self.view);
		make.bottom.equalTo(self.view).offset(-32.0);
		make.width.equalTo(_tableView);
	}];

	[disclaimerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(reportErrorButton);
		make.bottom.equalTo(reportErrorButton.mas_top).offset(4.0);
	}];

	[statusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view);
		make.trailing.leading.equalTo(self.view);
		make.height.equalTo(@20.0);
	}];

	[grayStatusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(statusBarView.mas_bottom);
		make.trailing.leading.equalTo(self.view);
		make.height.equalTo(@16.0);
	}];

	[_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(16.0, 16.0, 0.0, 16.0));
	}];

	[_spinner mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
	}];

	[_emptyResultsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
	}];

	[self.viewModel registerTableView:_tableView];

	[self setupReactiveStuff];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.viewModel.shouldHideKeyboardOnScroll = YES;
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[[RACObserve(self.viewModel, mode)
		ignore:nil]
		subscribeNext:^(NSNumber *modeNumber) {
			@strongify(self);

			self.spinner.alpha = modeNumber.integerValue == TKSSearchTaxiModeSearching ? 1.0 : 0.0;
			self.emptyResultsLabel.hidden = modeNumber.integerValue != TKSSearchTaxiModeError;
		}];
}

@end
