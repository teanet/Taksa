@class TKSSuggest;
@class TKSTaxiSection;

@interface TKSTaxiResults : NSObject

@property (nonatomic, copy, readonly) NSArray<TKSTaxiSection *> *taxiSections;

- (void)fetchTaxiResultsFromSuggest:(TKSSuggest *)fromSuggest
						  toSuggest:(TKSSuggest *)toSuggest;

@end
