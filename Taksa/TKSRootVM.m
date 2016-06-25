#import "TKSRootVM.h"

#import "TKSOrderVM.h"
#import "TKSDataProvider.h"

@interface TKSRootVM ()

@property (nonatomic, copy, readwrite) NSString *selectCityButtonTitle;

@end

@implementation TKSRootVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;
	
	@weakify(self);

	_inputVM = [[TKSInputVM alloc] init];
	[_inputVM.didBecomeEditingSignal subscribeNext:^(id _) {
		@strongify(self);

		if ([TKSDataProvider sharedProvider].currentRegion)
		{
			[self searchAddress];
		}
		else
		{
			[self selectCity];
		}
	}];

	_searchAddressSignal = [[self rac_signalForSelector:@checkselector0(self, searchAddress)]
		map:^TKSOrderVM *(id _) {
			@strongify(self);

			return [[TKSOrderVM alloc] initWithInputVM:self.inputVM];
		}];

	[[RACObserve([TKSDataProvider sharedProvider], currentRegion)
		takeUntil:self.rac_willDeallocSignal]
		subscribeNext:^(TKSRegion *currentRegion) {
			self.selectCityButtonTitle = currentRegion ? currentRegion.name : @"Определяю город...";
		}];

	[[[TKSDataProvider sharedProvider] fetchCurrentRegion]
		subscribeNext:^(id _) {
		}];

	_selectCitySignal = [[self rac_signalForSelector:@checkselector0(self, selectCity)]
		map:^TKSSelectCityVM *(id _) {
			return [[TKSSelectCityVM alloc] init];
		}];

	return self;
}

- (void)searchAddress
{
}

- (void)selectCity
{
}

@end
