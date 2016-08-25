#import "TKSTextField.h"

#import "UIColor+DGSCustomColor.h"

@interface TKSTextField ()

@property (nonatomic, strong, readonly) UILabel *letterLabel;
@property (nonatomic, strong, readonly) UIButton *locationButton;
@property (nonatomic, assign) BOOL enabledButton;

@end

@implementation TKSTextField

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	@weakify(self);

	self.backgroundColor = [UIColor whiteColor];
	self.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.autocorrectionType = UITextAutocorrectionTypeNo;

	self.font = [UIFont systemFontOfSize:14.0];

	_letterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 24.0, 24.0)];
	_letterLabel.layer.cornerRadius = 12.0;
	_letterLabel.layer.masksToBounds = YES;
	_letterLabel.backgroundColor = [UIColor dgs_colorWithString:@"F1DC00"];
	_letterLabel.textAlignment = NSTextAlignmentCenter;
	_letterLabel.textColor = [UIColor dgs_colorWithString:@"333333"];
	_letterLabel.font = [UIFont boldSystemFontOfSize:16.0];
	UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 56.0, 44.0)];
	[leftView addSubview:_letterLabel];
	_letterLabel.center = leftView.center;
	self.leftView = leftView;
	self.leftViewMode = UITextFieldViewModeAlways;

	_locationButton = [[UIButton alloc] init];
	[_locationButton setImage:[UIImage imageNamed:@"locationButton"] forState:UIControlStateNormal];
	[_locationButton addTarget:self.searchVM
						action:@checkselector0(self, didTapLocationButton)
			  forControlEvents:UIControlEventTouchUpInside];
	[_locationButton sizeToFit];
	self.rightViewMode = UITextFieldViewModeAlways;

	[self.rac_textSignal
		subscribeNext:^(NSString *text) {
			@strongify(self);

			self.searchVM.text = text;
		}];

	RACSignal *activeSignal = [[RACObserve(self, searchVM.active) ignore:nil] distinctUntilChanged];
	RACSignal *textSignal = [[RACObserve(self, searchVM.text) ignore:nil] distinctUntilChanged];

	RAC(self, text) = textSignal;
	RAC(self.locationButton, enabled) = [RACObserve(self, enabledButton) ignore:nil];

	[[textSignal
		deliverOnMainThread]
		subscribeNext:^(NSString *text) {
			@strongify(self);

			self.rightView = text.length > 0 ? nil : self.locationButton;
		}];

	[[textSignal
		filter:^BOOL(NSString *text) {
			return text.length > 0;
		}]
		subscribeNext:^(id x) {
			@strongify(self);

			[self swithToHighlighted:YES];
		}];

	[[activeSignal
		distinctUntilChanged]
		subscribeNext:^(NSNumber *active) {
			@strongify(self);

			if (active.boolValue)
			{
				[self becomeFirstResponder];
			}
			else
			{
				[self resignFirstResponder];
			}

			[self swithToHighlighted:active.boolValue];
		}];

	[[[RACObserve(self, searchVM)
		ignore:nil]
		deliverOnMainThread]
		subscribeNext:^(TKSSearchVM *searchVM) {
			@strongify(self);

			self.letterLabel.text = searchVM.letter;
			self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchVM.placeHolder attributes:@{
				NSForegroundColorAttributeName: [UIColor colorWithWhite:0.0 alpha:0.3],
				NSFontAttributeName: [UIFont systemFontOfSize:14.0]
			}];
		}];

	return self;
}

- (void)swithToHighlighted:(BOOL)highlighted
{
	CGFloat alpha = highlighted || self.text.length || self.searchVM.highlightedOnStart > 0
		? 1.0
		: 0.3;
	self.enabledButton = self.searchVM.highlightedOnStart || highlighted;
	self.searchVM.highlightedOnStart = NO;
	self.alpha = alpha;
}

- (void)didTapLocationButton
{
	[self.searchVM didTapLocationButton];
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
	CGRect originalRect = [super clearButtonRectForBounds:bounds];
	return CGRectOffset(originalRect, -9.0, 0.0); //shift the button to the left
}

@end
