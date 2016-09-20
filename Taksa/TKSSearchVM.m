#import "TKSSearchVM.h"

#import "TKSDataProvider.h"

@interface TKSSearchVM ()

@property (nonatomic, strong, readwrite) NSArray<TKSSuggest *> *suggests;
@property (atomic, assign) BOOL processingRequest;

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
	_processingRequest = NO;

	RACSignal *suggestListClearSignal = [[[[RACObserve(self, text) distinctUntilChanged]
		filter:^BOOL(NSString *text) {
			return text.length <= 1;
		}]
		throttle:0.3]
		mapReplace:nil];

	RACSignal *searchQuerySignal = [[[RACObserve(self, text)
		filter:^BOOL(NSString *text) {
			if (![text isEqualToString:self.dbObject.text])
			{
				self.dbObject = nil;
			}
			return text.length > 1;
		}]
		throttle:0.3]
		distinctUntilChanged];

	RACSignal *activeSignal = [[[RACObserve(self, active) ignore:nil]
		ignore:@NO]
		map:^NSString *(id _) {
			@strongify(self);

			return self.text;
		}];

	RACSignal *suggestListFillSignal = [[[[RACSignal merge:@[searchQuerySignal, activeSignal]]
		filter:^BOOL(NSString *inputText) {
			return ![inputText isEqualToString:self.dbObject.text] && [TKSDataProvider sharedProvider].currentRegion;
		}]
		flattenMap:^RACStream *(NSString *inputText) {
			return [[TKSDataProvider sharedProvider] fetchSuggestsForSearchString:inputText];
		}]
		catchTo:[RACSignal return:@[]]];

	[[RACSignal merge:@[suggestListClearSignal, suggestListFillSignal]]
		subscribeNext:^(NSArray<TKSSuggest *> *suggests) {
			@strongify(self);

			self.suggests = suggests;
			[suggests enumerateObjectsUsingBlock:^(TKSSuggest *suggest, NSUInteger _, BOOL *__) {
				NSLog(@">>> Suggest: %@", suggest.text);
			}];
		}];

	_didSelectLocationSuggestSignal = [[[self rac_signalForSelector:@checkselector(self, didSelectLocationSuggest:)]
		ignore:nil]
		map:^TKSSuggest *(RACTuple *tuple) {
			return tuple.first;
		}];

	return self;
}

- (void)didTapLocationButton
{
	@weakify(self);

	@synchronized (self)
	{
		if (!self.processingRequest)
		{
			self.processingRequest = YES;
			[[TKSDataProvider sharedProvider].fetchSuggestForLocation
				subscribeNext:^(NSArray<TKSSuggest *> *suggests) {
					@strongify(self);

					[self didSelectLocationSuggest:suggests.firstObject];
					self.processingRequest = NO;
				} error:^(NSError *error) {
					@strongify(self);

					self.processingRequest = NO;
				}];
		}
	}
}

- (void)didSelectLocationSuggest:(TKSSuggest *)suggest
{
	self.dbObject = suggest;
	self.text = suggest.text;
}

@end
