#import "TKSBaseVM.h"

#import "TKSInputVM.h"

typedef NS_ENUM (NSInteger, TKSSearchTaxiMode) {
	TKSSearchTaxiModeSuggest,
	TKSSearchTaxiModeSearching,
	TKSSearchTaxiModeResults,
	TKSSearchTaxiModeError,
};

@interface TKSSearchTaxiVM : TKSBaseVM

@property (nonatomic, assign) BOOL shouldHideKeyboardOnScroll;
@property (nonatomic, assign, readonly) TKSSearchTaxiMode mode;

- (instancetype)initWithInputVM:(TKSInputVM *)inputVM;

- (void)registerTableView:(UITableView *)tableView;

- (void)reportError;

- (void)hideKeyboard;

@end
