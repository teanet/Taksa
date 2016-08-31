#import "TKSTaxiHeaderCellVM.h"

@implementation TKSTaxiHeaderCellVM

- (instancetype)initWithTaxiSection:(TKSTaxiSection *)taxiSection
{
	self = [super init];
	if (self == nil) return nil;

	_taxiSection = taxiSection;

	return self;
}

@end


