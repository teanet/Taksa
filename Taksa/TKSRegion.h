#import "TKSSerializableProtocol.h"

/* Dictionary
	{
		"name": "Новосибирск",
		"id": "1",
		"type": "region"
	}
 */

@interface TKSRegion : NSObject <TKSSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *code;

@end
