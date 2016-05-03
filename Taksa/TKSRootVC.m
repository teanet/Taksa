#import "TKSRootVC.h"

#import "TKSSelectCityVC.h"
#import "TKSOrderVC.h"
#import "TKSInputView.h"
#import "TKSNavigationControllerDelegate.h"
#import "UIColor+DGSCustomColor.h"

@interface TKSRootVC ()
<UITextFieldDelegate>

@end

@implementation TKSRootVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	@weakify(self);

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
		make.top.equalTo(self.view).with.offset(34.0);
	}];

	UILabel *nameLabel = [[UILabel alloc] init];
	nameLabel.text = @"ТАКСА";
	nameLabel.textColor = [UIColor dgs_colorWithString:@"333333"];
	nameLabel.font = [UIFont systemFontOfSize:30.0];
	[self.view addSubview:nameLabel];
	[nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(logoView.mas_bottom).with.offset(19.0);
		make.centerX.equalTo(self.view);
	}];

	UILabel *descriptionLabel = [[UILabel alloc] init];
	descriptionLabel.numberOfLines = 0;
	descriptionLabel.text = @"Вынюхивает всё про таксистов и рекомендует лучших";
	descriptionLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.87];
	descriptionLabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:descriptionLabel];
	[descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(nameLabel.mas_bottom).with.offset(12.0);
		make.leading.equalTo(self.view).with.offset(20.0);
		make.trailing.equalTo(self.view).with.offset(-20.0);
	}];

	TKSInputVM *inputVM = [[TKSInputVM alloc] init];
	_inputView = [[TKSInputView alloc] initWithViewModel:inputVM];
	[self.view addSubview:_inputView];
	[_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(descriptionLabel.mas_bottom).with.offset(22.0);
		make.leading.equalTo(self.view);
		make.trailing.equalTo(self.view);
	}];

	[inputVM.didBecomeEditingSignal subscribeNext:^(id _) {
		@strongify(self);

		[self searchAddress];
	}];

	UIView *centerView = [[UIView alloc] init];
	[self.view addSubview:centerView];
	[centerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_inputView.mas_bottom).with.offset(12.0);
		make.bottom.equalTo(self.view);
		make.leading.equalTo(self.view);
		make.trailing.equalTo(self.view);
	}];

	UIButton *selectCity = [[UIButton alloc] init];
	[selectCity setTitle:@"Новосибирск ∨" forState:UIControlStateNormal];
	[selectCity setTitleColor:[[UIColor dgs_colorWithString:@"333333"] colorWithAlphaComponent:0.87] forState:UIControlStateNormal];

	[selectCity addTarget:self action:@checkselector0(self, selectCity) forControlEvents:UIControlEventTouchUpInside];
	[centerView addSubview:selectCity];
	[selectCity mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(centerView);
	}];

}

- (void)selectCity
{
	TKSSelectCityVC *selectCityVC = [[TKSSelectCityVC alloc] init];
	selectCityVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:selectCityVC] animated:YES completion:nil];
}

- (void)dismiss
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchAddress
{
	TKSOrderVC *orderVC = [[TKSOrderVC alloc] init];
	[self.navigationController setViewControllers:@[ orderVC ] animated:YES];
}

@end
