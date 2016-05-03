#import "TKSInputView.h"

#import "TKSTextField.h"
#import "UIColor+DGSCustomColor.h"

@interface TKSInputView ()
<UITextFieldDelegate>

@property (nonatomic, assign) BOOL costraintsCreated;

@end

@implementation TKSInputView

- (instancetype)initWithVM:(TKSInputVM *)inputVM
{
	self = [super initWithFrame:CGRectZero];
	if (self == nil) return nil;

	_inputVM = inputVM;
	
	_fromTF = [[TKSTextField alloc] initWithVM:inputVM.fromSearchVM];
	_fromTF.delegate = self;
	[self addSubview:_fromTF];

	_toTF = [[TKSTextField alloc] initWithVM:inputVM.toSearchVM];
	_toTF.delegate = self;
	[self addSubview:_toTF];

	return self;
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
			make.top.equalTo(self).with.offset(8.0);
			make.leading.equalTo(self).with.offset(16.0);
			make.trailing.equalTo(self).with.offset(-16.0);
			make.height.equalTo(@48.0);
		}];
		[self.toTF mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.fromTF.mas_bottom).with.offset(8.0);
			make.leading.equalTo(self).with.offset(16.0);
			make.trailing.equalTo(self).with.offset(-16.0);
			make.height.equalTo(@48.0);
			make.bottom.equalTo(self).with.offset(-8.0);
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
		self.inputVM.currentSearchVM = self.inputVM.fromSearchVM;
	}
	else if ([textField isEqual:self.toTF])
	{
		self.inputVM.currentSearchVM = self.inputVM.toSearchVM;
	}
}

@end
