//
//  UIWindow+WBHierarchy.m
//  WBCategories
//
//  Created by WMB on 2018/2/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIWindow+WBHierarchy.h"

@implementation UIWindow (WBHierarchy)

- (UIViewController *)wb_topMostController {
    UIViewController *topController = [self rootViewController];
    //  Getting topMost ViewController
    while ([topController presentedViewController])    topController = [topController presentedViewController];
    //  Returning topMost ViewController
    return topController;
}

- (UIViewController *)wb_currentController {
    UIViewController *currentViewController = [self wb_topMostController];
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    return currentViewController;
}
@end
