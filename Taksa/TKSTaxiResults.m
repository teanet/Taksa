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

	[[[TKSDataProvider sharedProvider] fetchTaxiListFromObject:fromSuggest toObject:toSuggest]
		subscribeNext:^(NSArray<TKSTaxiSection *> *taxiList) {
			@strongify(self);

			self.taxiSections = taxiList.count > 0 ? taxiList : @[];
		} error:^(NSError *error) {
			@strongify(self);

			self.taxiSections = @[];
		}];
}

@end
