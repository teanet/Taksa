#import "TKSSearchVM.h"

#import "TKSAPIController+TKSModels.h"

@interface TKSSearchVM ()

@property (nonatomic, strong, readwrite) NSArray<TKSSuggest *> *suggests;

@end

@implementation TKSSearchVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

		@weakify(self);

	RACSignal *suggestListClearSignal = [[[RACObserve(self, text)
		filter:^BOOL(NSString *text) {
			return text.length <= 1;
		}]
		throttle:0.3]
		mapReplace:nil];

	RACSignal *suggestListFillSignal = [[[RACObserve(self, text)
		filter:^BOOL(NSString *text) {
			return text.length > 1;
		}]
		throttle:0.3]
		flattenMap:^RACStream *(NSString *inputText) {
			return [[TKSAPIController sharedController] suggestsForString:inputText];
		}];

	[[RACSignal merge:@[suggestListClearSignal, suggestListFillSignal]]
		subscribeNext:^(NSArray<TKSSuggest *> *suggests) {
			@strongify(self);

			self.suggests = suggests;
			[suggests enumerateObjectsUsingBlock:^(TKSSuggest *suggest, NSUInteger _, BOOL *__) {
				NSLog(@">>> %@", suggest.text);
			}];
		}];

	return self;
}

@end
