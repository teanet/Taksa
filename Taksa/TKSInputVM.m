#import "TKSInputVM.h"

@implementation TKSInputVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_fromSearchVM = [[TKSSearchVM alloc] init];
	_fromSearchVM.placeHolder = @"Введите адрес";
	_fromSearchVM.letter = @"A";
	_fromSearchVM.highlightedOnStart = YES;

	_toSearchVM = [[TKSSearchVM alloc] init];
	_toSearchVM.placeHolder = @"Введите адрес";
	_toSearchVM.letter = @"B";

	_didBecomeEditingSignal = [[RACObserve(self, currentSearchVM)
		ignore:nil]
		mapReplace:nil];

	_didPressReturnButtonSignal = [[self rac_signalForSelector:@checkselector0(self, shouldStartSearchByReturn)]
		mapReplace:[RACUnit defaultUnit]];

	return self;
}

- (void)setCurrentSearchVM:(TKSSearchVM *)currentSearchVM
{
	if (_currentSearchVM == currentSearchVM) return;
	
	_currentSearchVM.active = NO;
	_currentSearchVM = currentSearchVM;
	_currentSearchVM.active = YES;
}

- (void)shouldStartSearchByReturn
{
}

@end
