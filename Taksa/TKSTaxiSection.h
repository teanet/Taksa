#import "TKSSerializableProtocol.h"
#import "TKSTaxiRow.h"

@interface TKSTaxiSection : NSObject <TKSSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *searchId;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSString *distance;
@property (nonatomic, copy, readonly) NSString *time;
@property (nonatomic, assign, readonly) TKSTaxiModelType type;
@property (nonatomic, copy, readonly) NSArray<TKSTaxiRow *> *rows;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
						  searchId:(NSString *)searchId
						  distance:(NSNumber *)distance
							  time:(NSNumber *)time
							  type:(TKSTaxiModelType)type;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_UNAVAILABLE;

@end


@interface TKSTaxiSection (TKSTest)

+ (instancetype)testGroupeSuggest;
+ (instancetype)testGroupeList;

@end


@interface NSArray (TKSTaxiSection)

+ (NSArray<TKSTaxiSection *> *)tks_sectionsWithDictionary:(NSDictionary *)dictionary;

@end

