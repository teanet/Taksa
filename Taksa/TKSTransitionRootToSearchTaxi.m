#import "TKSTransitionRootToSearchTaxi.h"

#import "TKSHomeVC.h"
#import "TKSInputView.h"
#import "TKSSearchTaxiVC.h"

@implementation TKSTransitionRootToSearchTaxi

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	TKSHomeVC *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	TKSSearchTaxiVC *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	UIView *containerView = [transitionContext containerView];
	NSTimeInterval duration = [self transitionDuration:transitionContext];

	UIView *inputView = [fromViewController.inputView snapshotViewAfterScreenUpdates:NO];
	inputView.frame = [fromViewController.view convertRect:fromViewController.inputView.frame toView:containerView];

	fromViewController.inputView.hidden = YES;
	toViewController.tableView.hidden = YES;

	// Setup the initial view states
	toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
	[toViewController.view layoutIfNeeded];
	[containerView addSubview:toViewController.view];
	[containerView addSubview:fromViewController.view];
	[containerView addSubview:inputView];

	CGRect frame = inputView.frame;
	frame.origin.y = 36.0;

	[UIView animateWithDuration:duration
						  delay:0.0
		 usingSpringWithDamping:0.7
		  initialSpringVelocity:0.5
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{

						 fromViewController.view.alpha = 0.0;
						 inputView.frame = frame;

					 } completion:^(BOOL finished) {
						 [inputView removeFromSuperview];
						 fromViewController.inputView.hidden = NO;
						 toViewController.tableView.hidden = NO;

						 // Clean up
						 fromViewController.view.alpha = 1.0;
						 fromViewController.view.hidden = NO;

						 // Declare that we've finished
						 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
					 }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return 0.5;
}

@end
