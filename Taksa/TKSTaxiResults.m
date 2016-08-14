#import "TKSTaxiResults.h"

#import "TKSSuggest.h"
#import "TKSDataProvider.h"

@interface TKSTaxiResults ()

@property (nonatomic, copy, readwrite) NSArray<TKSTaxiSection *> *taxiSections;

@end

@implementation TKSTaxiResults

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_taxiSections = @[];

	return self;
}

- (void)fetchTaxiResultsFromSuggest:(TKSSuggest *)fromSuggest
						  toSuggest:(TKSSuggest *)toSuggest
{
	@weakify(self);

	[[[[TKSDataProvider sharedProvider] fetchTaxiListFromObject:fromSuggest toObject:toSuggest]
		delay:1.0]
		subscribeNext:^(NSArray<TKSTaxiSection *> *taxiList) {
			@strongify(self);

			self.taxiSections = taxiList.count > 0 ? taxiList : @[];
		}];
}

@end
