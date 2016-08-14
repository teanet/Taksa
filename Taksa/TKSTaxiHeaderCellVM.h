#import "TKSBaseVM.h"

#import "TKSTaxiSection.h"

@interface TKSTaxiHeaderCellVM : TKSBaseVM

@property (nonatomic, strong, readonly) TKSTaxiSection *taxiSection;

- (instancetype)initWithTaxiSection:(TKSTaxiSection *)taxiSection NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end
