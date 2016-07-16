#import "TKSInputVM.h"

#import "TKSSuggestListVM.h"
#import "TKSHistoryListVM.h"
#import "TKSTaxiListVM.h"

typedef NS_ENUM(NSUInteger, TKSOrderMode) {
	TKSOrderModeSearch = 0,
	TKSOrderModeLoading,
	TKSOrderModeTaxiList,
};

@interface TKSOrderVM : NSObject

@property (nonatomic, strong, readonly) TKSInputVM *inputVM;
@property (nonatomic, strong, readonly) TKSSuggestListVM *suggestListVM;
@property (nonatomic, strong, readonly) TKSHistoryListVM *historyListVM;
@property (nonatomic, strong, readonly) TKSTaxiListVM *taxiListVM;
@property (nonatomic, strong, readonly) RACSignal *shouldResignFirstResponderSignal;
@property (nonatomic, assign, readonly) TKSOrderMode orderMode;

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM;

- (void)registerTaxiTableView:(UITableView *)tableView;
- (void)registerSuggestTableView:(UITableView *)tableView;

/*! \sendNext @[TKSTaxiSection] */
- (RACSignal *)fetchTaxiList;

@end
