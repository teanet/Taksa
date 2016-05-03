#import "TKSInputVM.h"

@interface TKSInputVM ()
@end

@implementation TKSInputVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_fromSearchVM = [[TKSSearchVM alloc] init];
	_fromSearchVM.placeHolder = @"Адрес, или название фирмы";
	
	_toSearchVM = [[TKSSearchVM alloc] init];

	_didBecomeEditingSignal = [[RACObserve(self, currentSearchVM)
		ignore:nil]
		mapReplace:nil];

	return self;
}

@end
