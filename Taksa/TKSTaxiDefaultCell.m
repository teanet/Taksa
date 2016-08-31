#import "TKSTaxiDefaultCell.h"

#import "UIFont+DGSCustomFont.h"
#import "UIColor+DGSCustomColor.h"

@interface TKSTaxiDefaultCell ()

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *priceLabel;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, strong, readonly) UILabel *letterLabel;

@end

@implementation TKSTaxiDefaultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (!self) return nil;

	self.selectionStyle = UITableViewCellSelectionStyleNone;

	UIView *container = [[UIView alloc] init];
	[self.contentView addSubview:container];

	_iconView = [[UIImageView alloc] init];
	_iconView.layer.cornerRadius = 16.0;
	[container addSubview:_iconView];

	UIView *textContainter = [[UIView alloc] init];
	[container addSubview:textContainter];

	_letterLabel = [[UILabel alloc] init];
	_letterLabel.font = [UIFont dgs_regularFontOfSize:16.0];
	[container addSubview:_letterLabel];

	_nameLabel = [[UILabel alloc] init];
	_nameLabel.font = [UIFont dgs_regularFontOfSize:14.0];
	[textContainter addSubview:_nameLabel];

	_priceLabel = [[UILabel alloc] init];
	_priceLabel.textAlignment = NSTextAlignmentRight;
	_priceLabel.font = [UIFont dgs_boldFontOfSize:14.0];
	[textContainter addSubview:_priceLabel];

	_descriptionLabel = [[UILabel alloc] init];
	_descriptionLabel.font = [UIFont dgs_regularFontOfSize:14.0];
	_descriptionLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
	[textContainter addSubview:_descriptionLabel];

	UIView *separatorView = [[UIView alloc] init];
	separatorView.backgroundColor = [UIColor dgs_colorWithString:@"F4F4F4"];
	[container addSubview:separatorView];

	[container mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView);
	}];

	[_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.equalTo(container).with.offset(16.0);
		make.width.equalTo(@32.0);
		make.height.equalTo(@32.0);
		make.bottom.equalTo(container).with.offset(-16.0);
	}];

	[_letterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(_iconView);
	}];

	[textContainter mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(_iconView.mas_trailing).with.offset(8.0);
		make.trailing.equalTo(container).with.offset(-16.0);
		make.height.lessThanOrEqualTo(container).with.offset(-16.0);
		make.centerY.equalTo(_iconView);
	}];

	[_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(textContainter);
		make.top.equalTo(textContainter);
	}];

	[_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.equalTo(textContainter);
		make.centerY.equalTo(_nameLabel);
		make.leading.greaterThanOrEqualTo(_nameLabel.mas_trailing);
	}];

	[_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_nameLabel.mas_bottom).with.offset(4.0);
		make.bottom.equalTo(textContainter);
		make.leading.equalTo(_nameLabel);
		make.trailing.equalTo(textContainter);
	}];

	[separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.bottom.trailing.equalTo(container);
		make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
	}];

	return self;
}

- (void)setViewModel:(id)viewModel
{
	[super setViewModel:viewModel];

	self.nameLabel.text	= self.viewModel.taxiRow.title;

	NSString *description = self.viewModel.taxiRow.phoneText;
	description = self.viewModel.taxiRow.site.length > 0
		? self.viewModel.taxiRow.site
		: description;
	self.descriptionLabel.text = description;
	self.priceLabel.text = [self.viewModel.taxiRow.price stringByAppendingString:@" ₽"];;
	self.iconView.backgroundColor = self.viewModel.taxiRow.color;
	self.letterLabel.text = [self.viewModel.taxiRow.title substringWithRange:NSMakeRange(0, 1)];
	self.letterLabel.textColor = self.viewModel.taxiRow.textColor;
}

@end
