#import "TKSSerializableProtocol.h"

@interface TKSRoute : NSObject <TKSSerializableProtocol>

@property (nonatomic, assign, readonly) double distance;
@property (nonatomic, assign, readonly) NSInteger duration;

@end
