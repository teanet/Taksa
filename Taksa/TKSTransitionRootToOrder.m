#import "TKSTransitionRootToOrder.h"

#import "TKSRootVC.h"
#import "TKSOrderVC.h"
#import "TKSInputView.h"

@implementation TKSTransitionRootToOrder

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	TKSRootVC *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	TKSOrderVC *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	UIView *containerView = [transitionContext containerView];
	NSTimeInterval duration = [self transitionDuration:transitionContext];

	UIView *inputView = [fromViewController.inputView snapshotViewAfterScreenUpdates:NO];
	inputView.frame = [fromViewController.view convertRect:fromViewController.inputView.frame toView:containerView];

	fromViewController.inputView.hidden = YES;

	toViewController.inputView.hidden = YES;
	toViewController.historyListVC.view.hidden = YES;

	// Get a snapshot of the image view

	// Setup the initial view states
	toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
	[toViewController.view layoutIfNeeded];
	[containerView addSubview:toViewController.view];
	[containerView addSubview:fromViewController.view];
	[containerView addSubview:inputView];

	[UIView animateWithDuration:duration animations:^{

		fromViewController.view.alpha = 0.0;
		inputView.frame = [toViewController.view convertRect:toViewController.inputView.frame toView:containerView];

	} completion:^(BOOL finished) {

		[inputView removeFromSuperview];
		fromViewController.inputView.hidden = NO;
		toViewController.inputView.hidden = NO;
		// Show History
		toViewController.historyListVC.view.alpha = 0.0;
		toViewController.historyListVC.view.hidden = NO;

		[UIView animateWithDuration:0.3 animations:^{
			toViewController.historyListVC.view.alpha = 1.0;
		}];

		// Clean up
		fromViewController.view.alpha = 1.0;
		fromViewController.view.hidden = NO;

		// Declare that we've finished
		[transitionContext completeTransition:!transitionContext.transitionWasCancelled];
	}];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return 0.3;
}

@end
