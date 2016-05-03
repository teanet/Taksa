#import "TKSTextField.h"

#import "UIColor+DGSCustomColor.h"

@interface TKSTextField ()

@property (nonatomic, strong, readonly) UILabel *letterLabel;

@end

@implementation TKSTextField

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	self.backgroundColor = [UIColor whiteColor];
	self.clearButtonMode = UITextFieldViewModeWhileEditing;

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

	return self;
}

- (void)setLetter:(NSString *)letter
{
	_letter = letter;
	_letterLabel.text = letter;
}

@end
