#import "TKSSerializableProtocol.h"
/*!
{
	"id": "141476222741093",
	"type": "street",
	"type_text": "улица",
	"text": "Ленина"
}
*/

@interface TKSSuggestObject : NSObject <TKSSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *typeText;
@property (nonatomic, copy, readonly) NSString *text;

@end
