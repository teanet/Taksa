#import "TKSHistoryCell.h"

@implementation TKSHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	if (self == nil) return nil;

	self.imageView.image = [UIImage imageNamed:@"historyIcon"];

	return self;
}

- (void)setViewModel:(id)viewModel
{
	[super setViewModel:viewModel];

//	self.textLabel.numberOfLines = 1;
	self.textLabel.attributedText = self.viewModel.attributedText;
	self.detailTextLabel.text = self.viewModel.hintTypeDescription;
}

@end
