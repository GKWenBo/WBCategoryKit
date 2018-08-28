//
//  UIViewController+WBRemoveTabbarButton.m
//  Demo
//
//  Created by WMB on 2017/10/10.
//  Copyright © 2017年 WMB. All rights reserved.
//

#import "UIViewController+WBRemoveTabbarButton.h"

@implementation UIViewController (WBRemoveTabbarButton)

- (void)wb_removeTabbarButton {
    if (self.navigationController.viewControllers.count > 1) {
        return;
    }
    UITabBarController *tabbarController = self.tabBarController;
    if (tabbarController) {
        UITabBar *tabbar = self.tabBarController.tabBar;
        
        if (tabbar) {
            for (UIView *view in tabbar.subviews) {
                Class c = NSClassFromString(@"UITabBarButton");
                if ([view isKindOfClass:c]) {
                    [view removeFromSuperview];
                }
            }
        }
    }
}

@end
