#import "TKSRootVM.h"

#import "TKSDataProvider.h"
#import "DGSErrorBannerVM.h"

@implementation TKSRootVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_errorBannerVM = [[DGSErrorBannerVM alloc] initWithAutohideMode:DGSErrorBannerAutohideModeByTouch];

	@weakify(self);

	[[[TKSDataProvider sharedProvider] errorSignal]
		subscribeNext:^(NSError *error) {
			@strongify(self);

			NSString *message = @"Ошибка: ";
			[self.errorBannerVM showMessage:[message stringByAppendingString:error.localizedDescription]];
		}];

	return self;
}

@end
