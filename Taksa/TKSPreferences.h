@interface TKSPreferences : NSObject

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *sessionId;

- (void)addSuggestDictionaryToHistoryList:(NSDictionary *)suggestDictionary;
- (NSArray<NSDictionary *> *)historyDictionaries;

@end
