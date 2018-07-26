//
//  UINavigationController+WBStatusBarStyle.m
//  WBManageStatusBarStyleDemo
//
//  Created by 文波 on 2018/7/26.
//  Copyright © 2018年 文波. All rights reserved.
//

#import "UINavigationController+WBStatusBarStyle.h"
#import <objc/runtime.h>

static char kWBDefaultStatusBarStyleKey;
static char kWBStatusBarStyleKey;

@implementation UINavigationController (WBStatusBarStyle)

+ (void)wb_setDefaultStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    objc_setAssociatedObject(self, &kWBDefaultStatusBarStyleKey, @(statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIStatusBarStyle)wb_DefaultStatusBarStyle {
    id style = objc_getAssociatedObject(self, &kWBDefaultStatusBarStyleKey);
    return style ? [style integerValue] : UIStatusBarStyleDefault;
}

/** < Override to return a child view controller or nil. If non-nil, that view controller's status bar appearance attributes will be used. If nil, self is used. Whenever the return values from these methods change, -setNeedsUpdatedStatusBarAttributes should be called. > */
//- (UIViewController *)childViewControllerForStatusBarStyle {
//    return self.topViewController;
//}
//
//- (UIViewController *)childViewControllerForStatusBarHidden {
//    return self.topViewController;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController wb_statusBarStyle];
}

@end

@implementation UIViewController (WBStatusBarStyle)

- (void)setWb_statusBarStyle:(UIStatusBarStyle)wb_statusBarStyle {
    objc_setAssociatedObject(self, &kWBStatusBarStyleKey, @(wb_statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    /** < Whenever the return values from these methods change, -setNeedsUpdatedStatusBarAttributes should be called. > */
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)wb_statusBarStyle {
    id style = objc_getAssociatedObject(self, &kWBStatusBarStyleKey);
    return style ? [style integerValue] : [UINavigationController wb_DefaultStatusBarStyle];
}

@end
