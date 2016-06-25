#import "TKSTaxiDefaultCell.h"

#import "UIFont+DGSCustomFont.h"

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

	_iconView = [[UIImageView alloc] init];
	_iconView.layer.cornerRadius = 16.0;
	[self.contentView addSubview:_iconView];

	_letterLabel = [[UILabel alloc] init];
	_letterLabel.font = [UIFont dgs_regularFontOfSize:16.0];
	[self.contentView addSubview:_letterLabel];

	_nameLabel = [[UILabel alloc] init];
	_nameLabel.font = [UIFont dgs_regularFontOfSize:14.0];
	[self.contentView addSubview:_nameLabel];

	_priceLabel = [[UILabel alloc] init];
	_priceLabel.textAlignment = NSTextAlignmentRight;
	_priceLabel.font = [UIFont dgs_regularFontOfSize:14.0];
	[self.contentView addSubview:_priceLabel];

	_descriptionLabel = [[UILabel alloc] init];
	_descriptionLabel.font = [UIFont dgs_regularFontOfSize:14.0];
	_descriptionLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
	[self.contentView addSubview:_descriptionLabel];

	[_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self.contentView).with.offset(8.0);
		make.top.equalTo(self.contentView).with.offset(8.0);
		make.width.equalTo(@32.0);
		make.height.equalTo(@32.0);
	}];

	[_letterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(_iconView);
	}];

	[_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(_iconView.mas_trailing).with.offset(8.0);
		make.top.equalTo(_iconView);
	}];

	[_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.equalTo(self.contentView).with.offset(-8.0);
		make.centerY.equalTo(_iconView);
	}];

	[_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_nameLabel.mas_bottom).with.offset(4.0);
		make.bottom.equalTo(self.contentView).with.offset(-4.0).with.priorityHigh();
		make.leading.equalTo(_nameLabel);
		make.trailing.equalTo(self.contentView).with.offset(-10.0);
	}];

	return self;
}

- (void)setTaxiRow:(TKSTaxiRow *)taxiRow
{
	self.nameLabel.text	= taxiRow.name;
	self.descriptionLabel.text = taxiRow.contact;
	self.priceLabel.text = [taxiRow.price stringByAppendingString:@" ₽"];;
	self.iconView.backgroundColor = taxiRow.color;
	self.letterLabel.text = [taxiRow.name substringWithRange:NSMakeRange(0, 1)];
	self.letterLabel.textColor = [self isLightColor:taxiRow.color]
		? [UIColor blackColor]
		: [UIColor whiteColor];
}

- (BOOL)isLightColor:(UIColor *)color
{
	CGFloat white = 0;
	[color getWhite:&white alpha:nil];
	return (white >= 0.5);
}

@end
