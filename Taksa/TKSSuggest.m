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

/*!
 {
	 "highlights": [{
		 "style": "normal",
		 "text": "Пролетарская"
	 }],
	 "text": "Пролетарская",
	 "id": "141476222740914",
	 "type_text": "Улица",
	 "type": "street"
 }
 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_id = dictionary[@"id"];
	_text = dictionary[@"text"];

	NSArray<NSDictionary *> *hintItemDictionaries = dictionary[@"highlights"];
	_hintItems = [hintItemDictionaries.rac_sequence
		map:^TKSHintItem *(NSDictionary *hintItemDictionary) {
			return [[TKSHintItem alloc] initWithDictionary:hintItemDictionary];
		}].array;

	_hintTypeDescription = dictionary[@"type_text"];
	_hintLabel = dictionary[@"type"];

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
