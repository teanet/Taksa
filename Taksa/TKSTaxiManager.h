#import "TKSTaxi.h"
#import "TKSTaxiSection.h"
#import "TKSRoute.h"

/*! Класс для данных, которые подкладываются локально на клиент.
	Чтобы сгенерить данные для поставщиков такси, нужно:
	1. Открыть https://docs.google.com/spreadsheets/d/1vmXFMnl7ECewxub1QFbwyp5hUWVZLTC5JnBt2x9LABk/edit#gid=0
	2. Сделать сохранение как csv
	3. На http://www.csvjson.com/csv2json сконвертить в json
	4. Положить taxiProviders.json по ссылке https://dl.dropboxusercontent.com/u/39349894/Taksa/taxiProviders.json
 */

@interface TKSTaxiManager : NSObject

@property (nonatomic, copy) NSArray<TKSTaxi *> *taxies;

- (NSArray<TKSTaxiSection *> *)sectionResultsForRoute:(TKSRoute *)route;

@end
