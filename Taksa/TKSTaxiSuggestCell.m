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

	self.selectionStyle = UITableViewCellSelectionStyleNone;

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
	_priceLabel.font = [UIFont dgs_boldFontOfSize:24.0];
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
		make.edges.equalTo(self.contentView);
	}];

	[_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(contentView).with.offset(16.0);
		make.top.equalTo(contentView).with.offset(16.0);
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
		make.trailing.equalTo(contentView).with.offset(-16.0);
		make.centerY.equalTo(_iconView);
	}];

	[_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_iconView.mas_bottom).with.offset(4.0);
		make.bottom.equalTo(contentView).with.offset(-16.0);
		make.leading.equalTo(_iconView);
		make.trailing.equalTo(contentView).with.offset(-16.0);
	}];

	return self;
}

- (void)setViewModel:(id)viewModel
{
	[super setViewModel:viewModel];

	self.nameLabel.text	= self.viewModel.taxiRow.title;
	self.descriptionLabel.text = self.viewModel.taxiRow.summary;
	self.priceLabel.text = [self.viewModel.taxiRow.price stringByAppendingString:@" ₽"];
	self.iconView.backgroundColor = self.viewModel.taxiRow.color;
	self.letterLabel.text = [self.viewModel.taxiRow.title substringWithRange:NSMakeRange(0, 1)];
	self.letterLabel.textColor = self.viewModel.taxiRow.textColor;
}

@end
