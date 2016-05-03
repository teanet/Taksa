#import "TKSInputView.h"

#import "TKSTextField.h"
#import "UIColor+DGSCustomColor.h"

@interface TKSInputView ()
<UITextFieldDelegate>

@property (nonatomic, assign) BOOL costraintsCreated;

@end

@implementation TKSInputView

- (instancetype)initWithViewModel:(TKSInputVM *)inputVM
{
	self = [super initWithFrame:CGRectZero];
	if (self == nil) return nil;
	@weakify(self);

	_inputVM = inputVM;
	
	_fromTF = [[TKSTextField alloc] init];
	_fromTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:inputVM.fromSearchVM.placeHolder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.0 alpha:0.3]}];
	_fromTF.delegate = self;
	_fromTF.letter = @"A";
	[[_fromTF.rac_textSignal
		throttle:0.3]
		subscribeNext:^(NSString *text) {
			@strongify(self);

			self.inputVM.fromSearchVM.text = text;
		}];
	[self addSubview:_fromTF];

	_toTF = [[TKSTextField alloc] init];
	_toTF.placeholder = inputVM.toSearchVM.placeHolder;
	_toTF.delegate = self;
	_toTF.letter = @"B";
	[[_toTF.rac_textSignal
		throttle:0.3]
		subscribeNext:^(NSString *text) {
			@strongify(self);

			self.inputVM.toSearchVM.text = text;
		}];
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
