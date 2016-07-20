#import "TKSTextField.h"

#import "UIColor+DGSCustomColor.h"

@interface TKSTextField ()

@property (nonatomic, strong, readonly) UILabel *letterLabel;

@end

@implementation TKSTextField

- (instancetype)initWithVM:(TKSSearchVM *)searchVM
{
	self = [super init];
	if (self == nil) return nil;
	@weakify(self);

	_searchVM = searchVM;

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
	UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 44.0)];
	[leftView addSubview:_letterLabel];
	_letterLabel.center = leftView.center;
	self.leftView = leftView;
	self.leftViewMode = UITextFieldViewModeAlways;

	_letterLabel.text = searchVM.letter;
	self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchVM.placeHolder attributes:@{
		NSForegroundColorAttributeName: [UIColor colorWithWhite:0.0 alpha:0.3],
		NSFontAttributeName: [UIFont systemFontOfSize:14.0]
	}];

	[self.rac_textSignal
		subscribeNext:^(NSString *text) {
			@strongify(self);

			self.searchVM.text = text;
		}];

	RACSignal *activeSignal = RACObserve(searchVM, active);
	RACSignal *textSignal = [RACObserve(self.searchVM, text) distinctUntilChanged];

	RAC(self, text) = textSignal;

	[activeSignal subscribeNext:^(NSNumber *active) {
		@strongify(self);

		if (active.boolValue)
		{
			[self becomeFirstResponder];
		}
		else
		{
			[self resignFirstResponder];
		}
	}];

	[[[[activeSignal combineLatestWith:textSignal]
		skip:1]
		startWith:RACTuplePack(@(searchVM.highlighted), @"")]
		subscribeNext:^(RACTuple *tuple) {
			@strongify(self);

			RACTupleUnpack(NSNumber *activeNumber, NSString *text) = tuple;

			[self swithToHighlighted:activeNumber.boolValue || text.length > 0];
		}];

	return self;
}

- (void)swithToHighlighted:(BOOL)highlighted
{
	CGFloat alpha = highlighted
		? 1.0
		: 0.3;
	self.alpha = alpha;
}

@end
