#import "TKSSuggestCell.h"

#import "UIColor+DGSCustomColor.h"

@interface TKSSuggestCell ()

@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, strong, readonly) UIView *textContainer;

@end

@implementation TKSSuggestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	if (self == nil) return nil;

	_iconImageView = [[UIImageView alloc] init];
	[self.contentView addSubview:_iconImageView];

	_textContainer = [[UIView alloc] init];
	[self.contentView addSubview:_textContainer];

	_titleLabel = [[UILabel alloc] init];
	_titleLabel.font = [UIFont systemFontOfSize:14.0];
	[_textContainer addSubview:_titleLabel];

	_subtitleLabel = [[UILabel alloc] init];
	_subtitleLabel.font = [UIFont systemFontOfSize:14.0];
	_subtitleLabel.textColor = [UIColor lightGrayColor];
	[_textContainer addSubview:_subtitleLabel];

	UIView *separatorView = [[UIView alloc] init];
	separatorView.backgroundColor = [UIColor dgs_colorWithString:@"F4F4F4"];
	[self.contentView addSubview:separatorView];

	[_iconImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh
													forAxis:UILayoutConstraintAxisHorizontal];
	[_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self.contentView).with.offset(16.0);
		make.centerY.equalTo(self.contentView);
		make.size.mas_equalTo(CGSizeMake(24.0, 24.0));
	}];

	[_textContainer setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
													forAxis:UILayoutConstraintAxisHorizontal];
	[_textContainer mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(_iconImageView.mas_trailing).with.offset(16.0);
		make.trailing.equalTo(self.contentView);
		make.centerY.equalTo(self.contentView);
	}];

	[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(_textContainer);
		make.top.equalTo(_textContainer);
		make.trailing.lessThanOrEqualTo(_textContainer);
		make.top.lessThanOrEqualTo(_textContainer);
	}];

	[_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_titleLabel.mas_bottom);
		make.leading.equalTo(_textContainer);
		make.trailing.lessThanOrEqualTo(_textContainer);
		make.top.greaterThanOrEqualTo(_textContainer);
		make.bottom.equalTo(_textContainer);
	}];

	[separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.contentView);
		make.trailing.equalTo(self.contentView);
		make.leading.equalTo(self.contentView);
		make.height.equalTo(@(1.0 / [UIScreen mainScreen].scale));
	}];

	return self;
}

- (void)setViewModel:(id)viewModel
{
	[super setViewModel:viewModel];

	self.titleLabel.attributedText = self.viewModel.attributedTitleText;
	self.subtitleLabel.text = self.viewModel.subtitleText;
	self.iconImageView.image = self.viewModel.iconImage;
}

@end
