#import "TKSTableSectionVM.h"

#import "TKSInputVM.h"

@interface TKSInputSectionVM : TKSTableSectionVM <TKSInputVM *>

// \sendNext RACTuple(TKSSuggest *from, TKSSuggest *to)
@property (nonatomic, strong, readonly) RACSignal *shouldSearchTaxiSignal;

- (void)didSelectCellVMAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TKSInputSectionVM () <TKSTableSectionVMProtocol>
@end
