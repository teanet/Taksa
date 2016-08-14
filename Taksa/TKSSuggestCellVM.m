#import "TKSSuggestCellVM.h"

@implementation TKSSuggestCellVM

- (instancetype)initWithSuggest:(TKSSuggest *)suggest type:(TKSCellType)type
{
	self = [super init];
	if (self == nil) return nil;

	_suggest = suggest;
	_type = type;
	_attributedTitleText = [suggest.attributedText copy];
	_subtitleText = [suggest.comment copy];
	_iconImage = [self imageForCellType:type];

	return self;
}

- (UIImage *)imageForCellType:(TKSCellType)type
{
	switch (type)
	{
		case TKSCellTypeSuggest: return [UIImage imageNamed:@"suggestIcon"];
		case TKSCellTypeHistory: return [UIImage imageNamed:@"historyIcon"];
	}
}

@end
