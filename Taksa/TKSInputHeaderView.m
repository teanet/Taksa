#import "TKSInputHeaderView.h"

#import "TKSInputView.h"
#import "UIColor+DGSCustomColor.h"

@interface TKSInputHeaderView ()

@property (nonatomic, strong, readonly) TKSInputView *inputView;

@end

@implementation TKSInputHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithReuseIdentifier:reuseIdentifier];
	if (self == nil) return nil;

	_inputView = [[TKSInputView alloc] init];
	self.contentView.backgroundColor = [UIColor dgs_colorWithString:@"F4F4F4"];
	[self.contentView addSubview:_inputView];

	[_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView).with.priorityHigh();
	}];

	return self;
}

- (void)setViewModel:(id)viewModel
{
	[super setViewModel:viewModel];

	self.inputView.viewModel = self.viewModel.model;
}

@end
