#import "TKSAPIController.h"

#import "TKSSuggest.h"
#import "TKSDatabaseObject.h"
#import "TKSTaxiGroupModel.h"

@interface TKSAPIController (TKSModels)

/*! \return NSArray<TKSSuggest *> */
- (RACSignal *)suggestsForString:(NSString *)searchString;

/*! \sendNext TKSDatabaseObject */
- (RACSignal *)objectForObjectId:(NSString *)objectId;
/*! \sendNext TKSDatabaseObject */
- (RACSignal *)objectForLocation:(CLLocation *)location;
/*! \sendNext TKSDatabaseObject */
- (RACSignal *)objectForSearchString:(NSString *)searchString;

/*! \sendNext @[TKSTaxiGroupModel] */
- (RACSignal *)taxiListFromObject:(TKSDatabaseObject *)objectFrom
						 toObject:(TKSDatabaseObject *)objectTo;

@end
