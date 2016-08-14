#import "TKSBaseVM.h"

#import "TKSTableViewCell.h"

@protocol TKSTableSectionVMProtocol <NSObject>

@property (nonatomic, copy, readonly) NSArray<TKSBaseVM *> *cellVMs;
@property (nonatomic, copy, readonly) NSString *headerTitleLeft;
@property (nonatomic, copy, readonly) NSString *headerTitleRight;

@end

@interface TKSTableSectionVM<ModelClass> : TKSBaseVM

@property (nonatomic, strong, readonly) RACSignal *shouldReloadTableSignal;
@property (nonatomic, strong, readonly) ModelClass model;

- (instancetype)initWithModel:(ModelClass)model NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)reloadSection;

@end
