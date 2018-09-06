//
//  UINavigationBar+WBBarStyle.m
//  WBManageStatusBarStyleDemo
//
//  Created by Mr_Lucky on 2018/8/28.
//  Copyright © 2018年 文波. All rights reserved.
//

#import "UINavigationBar+WBBarStyle.h"
#import <objc/runtime.h>

static char kWBDefaultStatusBarStyleKey;
static char kWBStatusBarStyleKey;

@implementation UINavigationBar (WBBarStyle)

+ (void)wb_setDefaultStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    objc_setAssociatedObject(self, &kWBDefaultStatusBarStyleKey, @(statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIStatusBarStyle)wb_DefaultStatusBarStyle {
    id style = objc_getAssociatedObject(self, &kWBDefaultStatusBarStyleKey);
    return style ? [style integerValue] : UIStatusBarStyleDefault;
}


@end

@implementation UINavigationController (WBBarStyle)

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

@implementation UIViewController (WBBarStyle)

- (void)setWb_statusBarStyle:(UIStatusBarStyle)wb_statusBarStyle {
    objc_setAssociatedObject(self, &kWBStatusBarStyleKey, @(wb_statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    /** < Whenever the return values from these methods change, -setNeedsUpdatedStatusBarAttributes should be called. > */
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)wb_statusBarStyle {
    id style = objc_getAssociatedObject(self, &kWBStatusBarStyleKey);
    return style ? [style integerValue] : [UINavigationBar wb_DefaultStatusBarStyle];
}

@end

