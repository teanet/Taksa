#import "TKSTaxiHeaderView.h"

#import "UIColor+DGSCustomColor.h"

@interface TKSTaxiHeaderView ()

@property (nonatomic, strong, readonly) UILabel *leftLabel;
@property (nonatomic, strong, readonly) UILabel *rightLabel;

@end

@implementation TKSTaxiHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithReuseIdentifier:reuseIdentifier];
	if (self == nil) return nil;

	self.contentView.backgroundColor = [UIColor dgs_colorWithString:@"F4F4F4"];

	_leftLabel = [self newLabel];
	[self.contentView addSubview:_leftLabel];

	_rightLabel = [self newLabel];
	_rightLabel.textAlignment = NSTextAlignmentRight;
	[self.contentView addSubview:_rightLabel];

	[_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.contentView);
		make.leading.equalTo(self.contentView).with.offset(16.0);
	}];

	[_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.contentView);
		make.trailing.equalTo(self.contentView).with.offset(-16.0);
		make.leading.equalTo(_leftLabel.mas_trailing);
	}];

	return self;
}

- (UILabel *)newLabel
{
	UILabel *label = [[UILabel alloc] init];
	label.font = [UIFont systemFontOfSize:14.0];
	label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
	return label;
}

- (void)setViewModel:(id)viewModel
{
	[super setViewModel:viewModel];

	NSString *title = self.viewModel.title;
	NSArray *components = [title componentsSeparatedByString:@"|"];
	self.leftLabel.text = components.firstObject;
	self.rightLabel.text = components.lastObject;
}

@end
