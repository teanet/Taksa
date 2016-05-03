#import "TKSNavigationControllerDelegate.h"

#import "TKSTransitionRootToOrder.h"
#import "TKSRootVC.h"
#import "TKSOrderVC.h"

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
	if ([fromVC isKindOfClass:[TKSRootVC class]] &&
		[toVC isKindOfClass:[TKSOrderVC class]])
	{
		return [[TKSTransitionRootToOrder alloc] init];
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
