#import "TKSSerializableProtocol.h"

typedef NS_ENUM(NSInteger, TKSTaxiModelType) {
	TKSTaxiModelTypeDefault = 0,
	TKSTaxiModelTypeSuggest = 1,
};

@interface TKSTaxiRow : NSObject <TKSSerializableProtocol>

@property (nonatomic, assign, readonly) TKSTaxiModelType type;
@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *shortTitle;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSString *site;
@property (nonatomic, copy, readonly) NSString *siteUrlString;
@property (nonatomic, copy, readonly) NSString *appUrlString;
@property (nonatomic, copy, readonly) NSString *phoneText;
@property (nonatomic, copy, readonly) NSString *phoneValue;
@property (nonatomic, strong, readonly) UIColor *color;
@property (nonatomic, strong, readonly) UIColor *textColor;
@property (nonatomic, copy, readonly) NSString *price;
@property (nonatomic, copy, readonly) NSString *searchId;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
						   summary:(NSString *)summary
						  searchId:(NSString *)searchId
							  type:(TKSTaxiModelType)type NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

