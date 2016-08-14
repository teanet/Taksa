#import "TKSInputView.h"

#import "TKSTextField.h"
#import "UIColor+DGSCustomColor.h"

@interface TKSInputView ()
<UITextFieldDelegate>

@property (nonatomic, strong, readonly) TKSTextField *fromTF;
@property (nonatomic, strong, readonly) TKSTextField *toTF;
@property (nonatomic, assign) BOOL costraintsCreated;

@end

@implementation TKSInputView

- (instancetype)init
{
	self = [super initWithFrame:CGRectZero];
	if (self == nil) return nil;
	
	_fromTF = [[TKSTextField alloc] init];
	_fromTF.delegate = self;
	[self addSubview:_fromTF];

	_toTF = [[TKSTextField alloc] init];
	_toTF.delegate = self;
	[self addSubview:_toTF];

	return self;
}

- (void)setViewModel:(TKSInputVM *)viewModel
{
	_viewModel = viewModel;

	self.fromTF.searchVM = viewModel.fromSearchVM;
	self.toTF.searchVM = viewModel.toSearchVM;
}

+ (BOOL)requiresConstraintBasedLayout
{
	return YES;
}

- (void)updateConstraints
{
	if (!self.costraintsCreated)
	{
		[self.fromTF mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).with.offset(16.0);
			make.leading.equalTo(self).with.offset(16.0);
			make.trailing.equalTo(self).with.offset(-16.0);
			make.height.equalTo(@48.0);
		}];
		[self.toTF mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.fromTF.mas_bottom).with.offset(8.0);
			make.leading.equalTo(self).with.offset(16.0);
			make.trailing.equalTo(self).with.offset(-16.0);
			make.height.equalTo(@48.0);
			make.bottom.equalTo(self).with.offset(-16.0);
		}];
		self.costraintsCreated = YES;
	}
	[super updateConstraints];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if ([textField isEqual:self.fromTF])
	{
		self.viewModel.currentSearchVM = self.viewModel.fromSearchVM;
	}
	else if ([textField isEqual:self.toTF])
	{
		self.viewModel.currentSearchVM = self.viewModel.toSearchVM;
	}

	self.viewModel.currentSearchVM.active = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.viewModel shouldStartSearchByReturn];

	return YES;
}

@end
