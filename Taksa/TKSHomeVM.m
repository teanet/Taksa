#import "TKSHomeVM.h"

#import "TKSSearchTaxiVM.h"
#import "TKSDataProvider.h"

#import "DGSMailSender.h"
#import "UIWindow+SIUtils.h"

@interface TKSHomeVM ()

@property (nonatomic, copy, readwrite) NSString *selectCityButtonTitle;

@end

@implementation TKSHomeVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;
	
	@weakify(self);

	_inputVM = [[TKSInputVM alloc] init];
	[_inputVM.didBecomeEditingSignal subscribeNext:^(id _) {
		@strongify(self);

		if ([TKSDataProvider sharedProvider].currentRegion)
		{
			[self searchAddress];
		}
		else
		{
			[self selectCity];
		}
	}];

	_searchAddressSignal = [[self rac_signalForSelector:@checkselector0(self, searchAddress)]
		map:^TKSSearchTaxiVM *(id _) {
			@strongify(self);

			return [[TKSSearchTaxiVM alloc] initWithInputVM:self.inputVM];
		}];

	[[RACObserve([TKSDataProvider sharedProvider], currentRegion)
		takeUntil:self.rac_willDeallocSignal]
		subscribeNext:^(TKSRegion *currentRegion) {
			self.selectCityButtonTitle = currentRegion ? currentRegion.title : @"Определяю город...";
		}];

	[[[TKSDataProvider sharedProvider] fetchCurrentRegion]
		subscribeNext:^(id _) {
		}];

	_selectCitySignal = [[self rac_signalForSelector:@checkselector0(self, selectCity)]
		map:^TKSSelectCityVM *(id _) {
			return [[TKSSelectCityVM alloc] init];
		}];

	return self;
}

- (void)searchAddress
{
}

- (void)selectCity
{
}

- (void)reportError
{
	UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.currentViewController;

	if ([DGSMailSender canSendMail])
	{
		NSString *contactEmail = @"taxi@2gis.ru";

		[DGSMailSender sendMailTo:@[contactEmail]
						  subject:@"Разработчикам Таксы"
					  messageBody:@""
					   isBodyHtml:NO
					  attachments:nil
				   rootController:topViewController
				completionHandler:nil];
	}
	else
	{
		[DGSMailSender showNoMailAlert];
	}
}

@end
