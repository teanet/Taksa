#import "TKSSuggest.h"

#import <DGSAttributedStringSuite/DGSAttributedStringSuite.h>
#import "UIFont+DGSCustomFont.h"

@implementation TKSHintItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_text = dictionary[@"text"];
	_style = [TKSHintItem styleForParameterString:dictionary[@"style"]];

	return self;
}

+ (TKSHintStyle)styleForParameterString:(NSString *)parameterString
{
	TKSHintStyle style = TKSHintStyleNormal;

	if ([parameterString isEqualToString:@"highlighted"])
	{
		style = TKSHintStyleHighlighted;
	}

	return style;
}

@end

@implementation TKSSuggest

@synthesize attributedText = _attributedText;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_id = dictionary[@"id"];
	NSDictionary *suggestDictionary = dictionary[@"hint"];

	NSArray<NSDictionary *> *hintItemDictionaries = suggestDictionary[@"highlighted_text"];
	NSMutableArray *mutableHintItems = [NSMutableArray arrayWithCapacity:hintItemDictionaries.count];

	[hintItemDictionaries enumerateObjectsUsingBlock:^(NSDictionary *hintDictionary, NSUInteger _, BOOL *__) {
		TKSHintItem *item = [[TKSHintItem alloc] initWithDictionary:hintDictionary];
		if (item)
		{
			[mutableHintItems addObject:item];
		}
	}];

	_hintItems = [mutableHintItems copy];
	_hintTypeDescription = suggestDictionary[@"hint_type"];
	_hintLabel = suggestDictionary[@"label"];
	_text = suggestDictionary[@"text"];

	return self;
}

- (NSAttributedString *)attributedText
{
	if (!_attributedText)
	{
		NSMutableAttributedString *mutableAttributedText = [[NSMutableAttributedString alloc] init];

		[self.hintItems enumerateObjectsUsingBlock:^(TKSHintItem *hintItem, NSUInteger _, BOOL * __) {
			[mutableAttributedText dgs_remakeString:^(DGSAttributedStringMaker *add) {
				if (hintItem.style == TKSHintStyleHighlighted)
				{
					add.string(hintItem.text).with.font([UIFont dgs_boldFontOfSize:15.0]);
				}
				else
				{
					add.string(hintItem.text).with.font([UIFont dgs_regularFontOfSize:15.0]);
				}
			}];
		}];

		_attributedText = [mutableAttributedText copy];
	}
	
	return _attributedText;
}

@end
