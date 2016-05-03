#import "TKSRegionCell.h"

@interface TKSRegionCell ()

@property (nonatomic, strong, readonly) UILabel *nameLabel;

@end

@implementation TKSRegionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (!self) return nil;

	_nameLabel = [[UILabel alloc] init];
	[self.contentView addSubview:_nameLabel];
	[_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self.contentView).with.offset(16.0);
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
		make.height.equalTo(@50.0);
	}];

	return self;
}

- (void)setRegion:(TKSRegion *)region
{
	_region = region;
	self.nameLabel.text = region.name;
}

@end
