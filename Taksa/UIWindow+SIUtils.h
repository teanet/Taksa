//
//  UIWindow+SIUtils.h
//  SIAlertView
//
//  Created by Kevin Cao on 13-11-1.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (SIUtils)

/*! ViewController, который учитывает иерархию вьюконтроллеров,
 *	чтобы правильно показать модальный вью контроллер.
 **/
- (UIViewController *)currentViewController;

#ifdef __IPHONE_7_0
- (UIViewController *)viewControllerForStatusBarStyle;
- (UIViewController *)viewControllerForStatusBarHidden;
#endif

@end
