//
//  UIWindow+SIUtils.m
//  SIAlertView
//
//  Created by Kevin Cao on 13-11-1.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import "UIWindow+SIUtils.h"

@implementation UIWindow (SIUtils)

- (UIViewController *)currentViewController
{
	return [self dgs_topViewControllerWithRootViewController:self.rootViewController];
}

- (UIViewController *)dgs_topViewControllerWithRootViewController:(UIViewController*)rootViewController
{

	// http://stackoverflow.com/a/17578272
	if ([rootViewController isKindOfClass:[UITabBarController class]])
	{
		UITabBarController *tabBarController = (UITabBarController *)rootViewController;
		return [self dgs_topViewControllerWithRootViewController:tabBarController.selectedViewController];
	}
	else if ([rootViewController isKindOfClass:[UINavigationController class]])
	{
		UINavigationController *navigationController = (UINavigationController *)rootViewController;
		return [self dgs_topViewControllerWithRootViewController:navigationController.visibleViewController];
	}
	else if (rootViewController.presentedViewController)
	{
		UIViewController *presentedViewController = rootViewController.presentedViewController;
		return [self dgs_topViewControllerWithRootViewController:presentedViewController];
	}
	else
	{
		return rootViewController;
	}
}

#ifdef __IPHONE_7_0

- (UIViewController *)viewControllerForStatusBarStyle
{
    UIViewController *currentViewController = [self currentViewController];
    
    while ([currentViewController childViewControllerForStatusBarStyle]) {
        currentViewController = [currentViewController childViewControllerForStatusBarStyle];
    }
    return currentViewController;
}

- (UIViewController *)viewControllerForStatusBarHidden
{
    UIViewController *currentViewController = [self currentViewController];
    
    while ([currentViewController childViewControllerForStatusBarHidden]) {
        currentViewController = [currentViewController childViewControllerForStatusBarHidden];
    }
    return currentViewController;
}

#endif

@end
