#import "TKSSearchVM.h"

#import "TKSDataProvider.h"

@interface TKSSearchVM ()

@property (nonatomic, strong, readwrite) NSArray<TKSSuggest *> *suggests;

@end

@implementation TKSSearchVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	@weakify(self);
	
	_letter = @" ";
	_placeHolder = @"";
	_text = @"";

	RACSignal *suggestListClearSignal = [[[RACObserve(self, text)
		filter:^BOOL(NSString *text) {
			return text.length <= 1;
		}]
		throttle:0.3]
		mapReplace:nil];

	RACSignal *searchQuerySignal = [[RACObserve(self, text)
		filter:^BOOL(NSString *text) {
			return text.length > 1;
		}]
		throttle:0.3];

	RACSignal *suggestListFillSignal = [searchQuerySignal
		flattenMap:^RACStream *(NSString *inputText) {
			return [[TKSDataProvider sharedProvider] fetchSuggestsForSearchString:inputText];
		}];


	[[RACSignal merge:@[suggestListClearSignal, suggestListFillSignal]]
		subscribeNext:^(NSArray<TKSSuggest *> *suggests) {
			@strongify(self);

			self.suggests = suggests;
			[suggests enumerateObjectsUsingBlock:^(TKSSuggest *suggest, NSUInteger _, BOOL *__) {
				NSLog(@">>> Suggest: %@", suggest.text);
			}];
		}];

	return self;
}

- (void)clearSuggestsAndResults
{
	self.suggests = nil;
}

@end
