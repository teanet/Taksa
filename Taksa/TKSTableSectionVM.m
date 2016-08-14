#import "TKSTableSectionVM.h"

@implementation TKSTableSectionVM

- (instancetype)initWithModel:(id)model
{
	self = [super init];
	if (self == nil) return nil;

	_model = model;

	_shouldReloadTableSignal = [[self rac_signalForSelector:@checkselector0(self, reloadSection)]
		mapReplace:[RACUnit defaultUnit]];

	return self;
}

- (void)reloadSection
{
}

@end
