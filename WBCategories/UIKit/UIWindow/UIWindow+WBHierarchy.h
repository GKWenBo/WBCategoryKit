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
 Get winow topmost controller.

 @return Returns the current Top Most ViewController in hierarchy.
 */
- (UIViewController *)wb_topMostController;

/**
 Get current controller.

 @return UReturns the topViewController in stack of topMostController.
 */
- (UIViewController *)wb_currentController;

@end
