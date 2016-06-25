#import "TKSSerializableProtocol.h"
#import "TKSTaxiRow.h"
#import "TKSTaxi.h"

/*
 {
	"title": "5.5км, 23 минуты",
	"summary": "Оптимальный выбор с учётом рейтинга перевозчика и популярности",
	"taxi_list": [
 {
 "type": "default/suggest",
 "name": "Uber",
 "contact": "uber://..",
 "price": "100",
 "color": "#CFCFCF",
 },
 {
 "type": "default/suggest",
 "name": "Uber",
 "contact": "uber://..",
 "price": "100",
 "color": "#CFCFCF",
 }
	],
 }
 */

@interface TKSTaxiSection : NSObject <TKSSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSArray<TKSTaxiRow *> *rows;

@end

@interface TKSTaxiSection (TKSLocalTaxi)

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray<TKSTaxiRow *> *)rows;

@end

@interface TKSTaxiSection (TKSTest)

+ (instancetype)testGroupeSuggest;
+ (instancetype)testGroupeList;

@end
