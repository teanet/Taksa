#import "TKSTaxiSuggestCell.h"

@interface TKSTaxiSuggestCell ()

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *priceLabel;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;

@end

@implementation TKSTaxiSuggestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (!self) return nil;

	UIView *contentView = [[UIView alloc] init];
	[self.contentView addSubview:contentView];

	_iconView = [[UIImageView alloc] init];
	[contentView addSubview:_iconView];

	_nameLabel = [[UILabel alloc] init];
	[contentView addSubview:_nameLabel];

	_priceLabel = [[UILabel alloc] init];
	_priceLabel.textAlignment = NSTextAlignmentRight;
	[contentView addSubview:_priceLabel];

	_descriptionLabel = [[UILabel alloc] init];
	_descriptionLabel.numberOfLines = 0;
	[contentView addSubview:_descriptionLabel];

	[contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0));
	}];

	[_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(contentView).with.offset(12.0);
		make.top.equalTo(contentView).with.offset(10.0);
		make.width.equalTo(@48.0);
		make.height.equalTo(@48.0);
	}];

	[_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(_iconView.mas_trailing).with.offset(8.0);
		make.centerY.equalTo(_iconView);
	}];

	[_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.equalTo(contentView).with.offset(-8.0);
		make.centerY.equalTo(_iconView);
	}];

	[_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_iconView.mas_bottom).with.offset(4.0);
		make.bottom.equalTo(contentView).with.offset(-4.0);
		make.leading.equalTo(_iconView);
		make.trailing.equalTo(contentView).with.offset(-10.0);
	}];

	return self;
}

- (void)setTaxiRow:(TKSTaxiRow *)taxiRow
{
	self.nameLabel.text	= taxiRow.name;
	self.descriptionLabel.text = taxiRow.summary;
	self.priceLabel.text = taxiRow.price;
	self.iconView.backgroundColor = taxiRow.color;
}

@end
