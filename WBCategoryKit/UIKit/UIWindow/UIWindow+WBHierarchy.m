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

+ (UIViewController *)wb_getTopViewController:(UIViewController *)inViewController {
    while (inViewController.presentedViewController) {
        inViewController = inViewController.presentedViewController;
    }
    if ([inViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedVC = [self wb_getTopViewController:((UITabBarController *)inViewController).selectedViewController];
        return selectedVC;
    } else if ([inViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *selectedVC = [self wb_getTopViewController:((UINavigationController *)inViewController).visibleViewController];
        return selectedVC;
    } else {
        return inViewController;
    }
}

+ (UIViewController *)wb_getCurrentDisplayController {
    __block UIWindow *normalWindow = [[UIApplication sharedApplication] keyWindow];
    NSArray *windows = [[UIApplication sharedApplication] windows];
    if (normalWindow.windowLevel != UIWindowLevelNormal) {
        [windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.windowLevel == UIWindowLevelNormal) {
                normalWindow = obj;
                *stop        = YES;
            }
        }];
    }
    return [self wb_getTopViewController:normalWindow.rootViewController];
}
@end
