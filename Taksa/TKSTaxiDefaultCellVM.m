#import "TKSTaxiDefaultCellVM.h"

@implementation TKSTaxiDefaultCellVM

- (instancetype)initWithTaxiRow:(TKSTaxiRow *)taxiRow
{
	self = [super init];
	if (self == nil) return nil;

	_taxiRow = taxiRow;

	return self;
}

@end
