#import "TKSBaseVM.h"

#import "TKSSuggest.h"

typedef NS_ENUM (NSInteger, TKSCellType) {
	TKSCellTypeSuggest = 0,
	TKSCellTypeHistory,
};

@interface TKSSuggestCellVM : TKSBaseVM

@property (nonatomic, strong, readonly) TKSSuggest *suggest;
@property (nonatomic, assign, readonly) TKSCellType type;
@property (nonatomic, copy, readonly) NSAttributedString *attributedTitleText;
@property (nonatomic, copy, readonly) NSString *subtitleText;
@property (nonatomic, copy, readonly) UIImage *iconImage;

- (instancetype)initWithSuggest:(TKSSuggest *)suggest type:(TKSCellType)type;

@end
