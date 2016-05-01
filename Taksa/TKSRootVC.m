#import "TKSRootVC.h"

#import "TKSSelectCityVC.h"
#import "TKSOrderVC.h"
#import "TKSInputView.h"

@interface TKSRootVC ()
<UITextFieldDelegate>

@end

@implementation TKSRootVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	@weakify(self);

	self.view.backgroundColor = [UIColor whiteColor];

	[self setEdgesForExtendedLayout:UIRectEdgeNone];

	TKSInputVM *inputVM = [[TKSInputVM alloc] init];
	TKSInputView *inputView = [[TKSInputView alloc] initWithViewModel:inputVM];
	[self.view addSubview:inputView];
	[inputView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view);
		make.leading.equalTo(self.view);
		make.trailing.equalTo(self.view);
	}];

	[inputVM.didBecomeEditingSignal subscribeNext:^(id _) {
		@strongify(self);

		[self searchAddress];
	}];

	UIButton *selectCity = [UIButton buttonWithType:UIButtonTypeContactAdd];
	[selectCity addTarget:self action:@checkselector0(self, selectCity) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:selectCity];
	[selectCity mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.top.equalTo(self.view).with.offset(200.0);
	}];
}

- (void)selectCity
{
	TKSSelectCityVC *selectCityVC = [[TKSSelectCityVC alloc] init];
	[self.navigationController pushViewController:selectCityVC animated:YES];
}

- (void)searchAddress
{
	TKSOrderVC *orderVC = [[TKSOrderVC alloc] init];
	[self.navigationController pushViewController:orderVC animated:YES];
}

@end
