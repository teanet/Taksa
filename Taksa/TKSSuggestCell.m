#import "TKSSuggestCell.h"

@implementation TKSSuggestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	if (self == nil) return nil;

	self.imageView.image = [UIImage imageNamed:@"suggestIcon"];

	return self;
}

- (void)setViewModel:(id)viewModel
{
	[super setViewModel:viewModel];

	self.textLabel.numberOfLines = 0;
	self.textLabel.attributedText = self.viewModel.attributedText;
	self.detailTextLabel.text = self.viewModel.hintTypeDescription;
}

@end
