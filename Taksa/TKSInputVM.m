#import "TKSInputVM.h"

@implementation TKSInputVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_fromSearchVM = [[TKSSearchVM alloc] init];
	_fromSearchVM.placeHolder = @"Адрес, или название фирмы";
	_fromSearchVM.letter = @"A";
	_fromSearchVM.highlighted = YES;

	_toSearchVM = [[TKSSearchVM alloc] init];
	_toSearchVM.placeHolder = @"Адрес, или название фирмы";
	_toSearchVM.letter = @"B";

	_didBecomeEditingSignal = [[RACObserve(self, currentSearchVM)
		ignore:nil]
		mapReplace:nil];

	return self;
}

- (void)setCurrentSearchVM:(TKSSearchVM *)currentSearchVM
{
	if (_currentSearchVM == currentSearchVM) return;
	
	_currentSearchVM.active = NO;
	_currentSearchVM = currentSearchVM;
	_currentSearchVM.active = YES;
}

@end
