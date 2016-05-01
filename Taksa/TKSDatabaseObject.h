#import "TKSSerializableProtocol.h"

/* Инитится со словарём вида:
{
	"purpose_name": "Жилой дом с административными помещениями",
	"name": "Красный проспект, 186",
	"full_name": "Новосибирск, Красный проспект, 186",
	"id": "141373143528394",
	"address_name": "Красный проспект, 186",
	"type": "building"
	"geometry": {
		"selection": "POINT(82.913568 55.058595)"
	}
}
*/
@interface TKSDatabaseObject : NSObject <TKSSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *fullName;
@property (nonatomic, copy, readonly) NSString *purposeName;
@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *addressName;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) CLLocation *location;

@end
