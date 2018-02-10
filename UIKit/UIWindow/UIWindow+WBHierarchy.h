//
//  UIWindow+WBHierarchy.h
//  WBCategories
//
//  Created by WMB on 2018/2/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (WBHierarchy)

/**
 Get winow top most controller.

 @return Returns the current Top Most ViewController in hierarchy.
 */
- (UIViewController *)wb_topMostController;

/**
 Get current controller.

 @return the topViewController in stack of topMostController.
 */
- (UIViewController *)wb_currentController;

/**
 Get top most controller in viewcontrollr.

 @param inViewController inViewController description
 @return the top most controller
 */
+ (UIViewController *)wb_getTopViewController:(UIViewController *)inViewController;

/**
 Get current dispay controller in screen.

 @return UIViewController
 */
+ (UIViewController *)wb_getCurrentDisplayController;

@end
