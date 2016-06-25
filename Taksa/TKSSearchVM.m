#import "TKSSearchVM.h"

#import "TKSDataProvider.h"

@interface TKSSearchVM ()

@property (nonatomic, strong, readwrite) NSArray<TKSSuggest *> *suggests;
@property (nonatomic, strong, readwrite) NSArray<TKSDatabaseObject *> *results;

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

	RACSignal *resultsListFillSignal = [searchQuerySignal
		flattenMap:^RACStream *(NSString *inputText) {
			return [[TKSDataProvider sharedProvider] fetchObjectsForSearchString:inputText];
		}];

	[[RACSignal merge:@[suggestListClearSignal, suggestListFillSignal]]
		subscribeNext:^(NSArray<TKSSuggest *> *suggests) {
			@strongify(self);

			self.suggests = suggests;
			[suggests enumerateObjectsUsingBlock:^(TKSSuggest *suggest, NSUInteger _, BOOL *__) {
				NSLog(@">>> Suggest: %@", suggest.text);
			}];
		}];

	[[RACSignal merge:@[suggestListClearSignal, resultsListFillSignal]]
		subscribeNext:^(NSArray<TKSDatabaseObject *> *results) {
			@strongify(self);

			self.results = results;
			[results enumerateObjectsUsingBlock:^(TKSDatabaseObject *dbObject, NSUInteger _, BOOL *__) {
				NSLog(@">>> Result: %@", dbObject.name);
			}];
		}];

	return self;
}

- (void)clearSuggestsAndResults
{
	self.suggests = nil;
	self.results = nil;
}

@end
