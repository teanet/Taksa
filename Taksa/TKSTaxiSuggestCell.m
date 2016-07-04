#import "TKSTaxiSuggestCell.h"

#import "UIFont+DGSCustomFont.h"

@interface TKSTaxiSuggestCell ()

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *priceLabel;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, strong, readonly) UILabel *letterLabel;

@end

@implementation TKSTaxiSuggestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (!self) return nil;

	UIView *contentView = [[UIView alloc] init];
	[self.contentView addSubview:contentView];

	_iconView = [[UIImageView alloc] init];
	_iconView.layer.cornerRadius = 24.0;
	[contentView addSubview:_iconView];

	_nameLabel = [[UILabel alloc] init];
	_nameLabel.font = [UIFont dgs_regularFontOfSize:24.0];
	_nameLabel.numberOfLines = 0;
	[contentView addSubview:_nameLabel];

	_priceLabel = [[UILabel alloc] init];
	_priceLabel.textAlignment = NSTextAlignmentRight;
	_priceLabel.font = [UIFont dgs_regularFontOfSize:24.0];
	[contentView addSubview:_priceLabel];

	_descriptionLabel = [[UILabel alloc] init];
	_descriptionLabel.numberOfLines = 0;
	_descriptionLabel.font = [UIFont dgs_regularFontOfSize:14.0];
	_descriptionLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
	[contentView addSubview:_descriptionLabel];

	_letterLabel = [[UILabel alloc] init];
	_letterLabel.font = [UIFont dgs_regularFontOfSize:24.0];
	[contentView addSubview:_letterLabel];

	[contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0));
	}];

	[_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(contentView).with.offset(12.0);
		make.top.equalTo(contentView).with.offset(10.0);
		make.width.equalTo(@48.0);
		make.height.equalTo(@48.0);
	}];

	[_letterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(_iconView);
	}];

	[_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(_iconView.mas_trailing).with.offset(8.0);
		make.centerY.equalTo(_iconView);
		make.trailing.equalTo(_priceLabel.mas_leading);
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
	self.nameLabel.text	= taxiRow.title;
	self.descriptionLabel.text = taxiRow.summary;
	self.priceLabel.text = [taxiRow.price stringByAppendingString:@" ₽"];
	self.iconView.backgroundColor = taxiRow.color;
	self.letterLabel.text = [taxiRow.title substringWithRange:NSMakeRange(0, 1)];
	self.letterLabel.textColor = taxiRow.textColor;
}

@end
