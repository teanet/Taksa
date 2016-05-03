#import "TKSInputVM.h"
#import "TKSSelectCityVM.h"

@class TKSOrderVM;

@interface TKSRootVM : NSObject

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;

@property (nonatomic, copy, readonly) NSString *selectCityButtonTitle;

/*! Signal with TKSOrderVM.
 *	
 *	\return TKSOrderVM.
 **/
@property (nonatomic, strong, readonly) RACSignal *searchAddressSignal;

/*! Signal with TKSSelectCityVM.
 *
 *	\return TKSSelectCityVM.
 **/
@property (nonatomic, strong, readonly) RACSignal *selectCitySignal;

- (void)searchAddress;
- (void)selectCity;

@end
