#import "TKSSerializableProtocol.h"

typedef NS_ENUM(NSInteger, TKSHintStyle) {
	TKSHintStyleNormal = 0,
	TKSHintStyleHighlighted = 1,
};

/*! Инитится со словарем вида: { style = highlighted/normal, text = "текст"} */
@interface TKSHintItem : NSObject <TKSSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, assign, readonly) TKSHintStyle style;

@end

/*!
 {
	"highlighted_text" =
	(
 {
 style = highlighted;
 text = "те";
 },
 {
 style = normal;
 text = "кст";
 }
	);
	"hint_type" = street;
	id = 141476222739705;
	label = street;
	text = "текст";
 };

 */
@interface TKSSuggest : NSObject <TKSSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) NSAttributedString *attributedText;
@property (nonatomic, copy, readonly) NSArray<TKSHintItem *> *hintItems;
@property (nonatomic, copy, readonly) NSString *hintTypeDescription;
@property (nonatomic, copy, readonly) NSString *hintLabel;
@property (nonatomic, copy, readonly) NSString *id;

@end
