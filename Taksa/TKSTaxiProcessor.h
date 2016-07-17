@class TKSTaxiRow;
@class TKSSuggest;

@interface TKSTaxiProcessor : NSObject

- (void)processTaxiRow:(TKSTaxiRow *)taxiRow
		   fromSuggest:(TKSSuggest *)fromSuggest
			 toSuggest:(TKSSuggest *)toSuggest;

@end
