#import "TKSBaseVM.h"

#import "TKSTaxiRow.h"

@interface TKSTaxiSuggestCellVM : TKSBaseVM

@property (nonatomic, strong, readonly) TKSTaxiRow *taxiRow;

- (instancetype)initWithTaxiRow:(TKSTaxiRow	*)taxiRow NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end
