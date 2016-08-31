#import "TKSNavigationControllerDelegate.h"

#import "TKSSearchTaxiVC.h"
#import "TKSHomeVC.h"
#import "TKSTransitionRootToSearchTaxi.h"

@implementation TKSNavigationControllerDelegate
{
	NSMutableDictionary *_transitions;
}

+ (instancetype)sharedDelegate
{
	static id manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[[self class] alloc] init];
	});
	return manager;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_transitions = [NSMutableDictionary dictionary];
	}
	return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
								  animationControllerForOperation:(UINavigationControllerOperation)operation
											   fromViewController:(UIViewController *)fromVC
												 toViewController:(UIViewController *)toVC
{
	if ([fromVC isKindOfClass:[TKSHomeVC class]] &&
		[toVC isKindOfClass:[TKSSearchTaxiVC class]])
	{
		return [[TKSTransitionRootToSearchTaxi alloc] init];
	}

	return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
	return nil;
}

@end
