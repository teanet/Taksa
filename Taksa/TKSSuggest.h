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
@interface TKSSuggest : NSObject <TKSSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) NSString *comment;
@property (nonatomic, copy, readonly) NSAttributedString *attributedText;
@property (nonatomic, copy, readonly) NSArray<TKSHintItem *> *hintItems;
@property (nonatomic, copy, readonly) NSString *hintTypeDescription;
@property (nonatomic, copy, readonly) NSString *hintLabel;

/*! Dictionary representation */
@property (nonatomic, copy, readonly) NSDictionary *dictionary;

@end
