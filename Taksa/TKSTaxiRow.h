#import "TKSSerializableProtocol.h"

typedef NS_ENUM(NSInteger, TKSTaxiModelType) {
	TKSTaxiModelTypeDefault = 0,
	TKSTaxiModelTypeSuggest = 1,
};

/*
	{
 "type": "default/suggest",
 "name": "Uber",
 "contact": "uber://..",
 "price": "100",
 "color": "#CFCFCF",
 "summary": "..."
	}
 */

@interface TKSTaxiRow : NSObject <TKSSerializableProtocol>

@property (nonatomic, assign, readonly) TKSTaxiModelType type;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *contact;
@property (nonatomic, copy, readonly) NSString *price;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, strong, readonly) UIColor *color;

@end
