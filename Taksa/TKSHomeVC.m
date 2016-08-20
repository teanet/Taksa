#import "TKSHomeVC.h"

#import "TKSSelectCityVC.h"
#import "TKSSearchTaxiVC.h"
#import "TKSInputView.h"
#import "TKSNavigationControllerDelegate.h"
#import "UIColor+DGSCustomColor.h"

@interface TKSHomeVC ()

@property (nonatomic, strong, readonly) UIButton *selectCityButton;
@property (nonatomic, strong, readonly) UIButton *reportErrorButton;

@end

@implementation TKSHomeVC

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	UIView *statusBarView = [[UIView alloc] init];
	statusBarView.backgroundColor = [UIColor dgs_colorWithString:@"FFC533"];
	[self.view addSubview:statusBarView];

	[statusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.trailing.equalTo(self.view);
		make.height.equalTo(@20.0);
	}];

	self.view.backgroundColor = [UIColor dgs_colorWithString:@"F4F4F4"];
	[self setEdgesForExtendedLayout:UIRectEdgeNone];
	self.navigationController.delegate = [TKSNavigationControllerDelegate sharedDelegate];

	UIImageView *logoView = [[UIImageView alloc] init];
	logoView.image = [UIImage imageNamed:@"logo"];
	[self.view addSubview:logoView];
	[logoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.width.equalTo(@80.0);
		make.height.equalTo(@80.0);
		make.top.equalTo(self.view).with.offset(84.0);
	}];

	UILabel *nameLabel = [[UILabel alloc] init];
	NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"ТАКСА" attributes:@{
		NSKernAttributeName : @(7.0)
	}];
	nameLabel.attributedText = attString;
	nameLabel.textColor = [UIColor dgs_colorWithString:@"333333"];
	nameLabel.font = [UIFont boldSystemFontOfSize:24.0];
	[self.view addSubview:nameLabel];
	[nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(logoView.mas_bottom).with.offset(19.0);
		make.centerX.equalTo(self.view);
	}];

	UILabel *descriptionLabel = [[UILabel alloc] init];
	descriptionLabel.numberOfLines = 0;
	descriptionLabel.text = @"Все такси города";
	descriptionLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.87];
	descriptionLabel.textAlignment = NSTextAlignmentCenter;
	descriptionLabel.font = [UIFont systemFontOfSize:14.0];
	[self.view addSubview:descriptionLabel];
	[descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(nameLabel.mas_bottom).with.offset(12.0);
		make.leading.equalTo(self.view).with.offset(20.0);
		make.trailing.equalTo(self.view).with.offset(-20.0);
	}];

	_inputView = [[TKSInputView alloc] init];
	_inputView.viewModel = self.viewModel.inputVM;
	[self.view addSubview:_inputView];
	[_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(descriptionLabel.mas_bottom).with.offset(22.0);
		make.leading.equalTo(self.view).with.offset(16.0);
		make.trailing.equalTo(self.view).with.offset(-16.0);
	}];

	UIView *centerView = [[UIView alloc] init];
	[self.view addSubview:centerView];
	[centerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view);
		make.leading.equalTo(self.view);
		make.trailing.equalTo(self.view);
	}];

	_selectCityButton = [[UIButton alloc] init];
	[_selectCityButton setTitle:@"Определяю город..." forState:UIControlStateNormal];
	[_selectCityButton setTitleColor:[[UIColor dgs_colorWithString:@"333333"] colorWithAlphaComponent:0.87]
							forState:UIControlStateNormal];
	[_selectCityButton addTarget:self.viewModel
						  action:@checkselector0(self.viewModel, selectCity)
				forControlEvents:UIControlEventTouchUpInside];
	[centerView addSubview:_selectCityButton];
	[_selectCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@32.0);
		make.leading.top.trailing.equalTo(centerView);
	}];

	// Report Error Button
	UIColor *mailColor = [UIColor dgs_colorWithString:@"FFC815"];
	NSDictionary *mailAttrs = @{ NSForegroundColorAttributeName : mailColor };
	NSDictionary *textAttrs = @{ NSForegroundColorAttributeName : [[UIColor blackColor] colorWithAlphaComponent:0.5] };

	NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"Для пожеланий и ошибок: "
																				attributes:textAttrs];
	NSAttributedString *mailStr = [[NSAttributedString alloc] initWithString:@"taxi@2gis.ru" attributes:mailAttrs];
	[attrStr appendAttributedString:mailStr];

	_reportErrorButton = [[UIButton alloc] init];
	[_reportErrorButton setAttributedTitle:attrStr forState:UIControlStateNormal];
	_reportErrorButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
	[_reportErrorButton setTitleColor:[[UIColor dgs_colorWithString:@"333333"] colorWithAlphaComponent:0.5]
							forState:UIControlStateNormal];
	[_reportErrorButton addTarget:self.viewModel
						   action:@checkselector0(self.viewModel, reportError)
				 forControlEvents:UIControlEventTouchUpInside];
	[centerView addSubview:_reportErrorButton];
	[_reportErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@32.0);
		make.leading.bottom.trailing.equalTo(centerView);
		make.top.equalTo(_selectCityButton.mas_bottom);
	}];

	[self setNeedsStatusBarAppearanceUpdate];

	[self setupReactiveStuff];
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[RACObserve(self.viewModel, selectCityButtonTitle) subscribeNext:^(NSString *title) {
		[self.selectCityButton setTitle:title forState:UIControlStateNormal];
	}];

	[self.viewModel.searchAddressSignal subscribeNext:^(TKSSearchTaxiVM *searchTaxiVM) {
		@strongify(self);

		TKSSearchTaxiVC *searchTaxiVC = [[TKSSearchTaxiVC alloc] initWithVM:searchTaxiVM];
		[self.navigationController setViewControllers:@[ searchTaxiVC ] animated:YES];
	}];

	[self.viewModel.selectCitySignal subscribeNext:^(TKSSelectCityVM *selectCityVM) {
		@strongify(self);

		void (^didCloseBlock)(id) = ^void(id _) {
			@strongify(self);
			[self dismissViewControllerAnimated:YES completion:nil];
		};
		[selectCityVM.didCloseSignal subscribeNext:didCloseBlock];
		[selectCityVM.didSelectRegionSignal subscribeNext:didCloseBlock];

		TKSSelectCityVC *selectCityVC = [[TKSSelectCityVC alloc] initWithVM:selectCityVM];
		[self presentViewController:[[UINavigationController alloc] initWithRootViewController:selectCityVC]
						   animated:YES completion:nil];
	}];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

@end
