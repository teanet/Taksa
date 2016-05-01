#import "TKSTaxiDefaultCell.h"

@interface TKSTaxiDefaultCell ()

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *priceLabel;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;

@end

@implementation TKSTaxiDefaultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (!self) return nil;

	_iconView = [[UIImageView alloc] init];
	[self.contentView addSubview:_iconView];

	_nameLabel = [[UILabel alloc] init];
	[self.contentView addSubview:_nameLabel];

	_priceLabel = [[UILabel alloc] init];
	_priceLabel.textAlignment = NSTextAlignmentRight;
	[self.contentView addSubview:_priceLabel];

	_descriptionLabel = [[UILabel alloc] init];
	[self.contentView addSubview:_descriptionLabel];

	[_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self.contentView).with.offset(8.0);
		make.top.equalTo(self.contentView).with.offset(8.0);
		make.width.equalTo(@32.0);
		make.height.equalTo(@32.0);
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
	self.priceLabel.text = taxiRow.price;
	self.iconView.backgroundColor = taxiRow.color;
}

@end
