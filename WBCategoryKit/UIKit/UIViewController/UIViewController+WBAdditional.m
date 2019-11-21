//
//  UIViewController+WBAdditional.m
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIViewController+WBAdditional.h"

@implementation UIViewController (WBAdditional)

- (void)wb_hideBackButton {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (NSArray <UIViewController *>*)wb_existingViewControllersOfClass:(Class)cls {
    NSMutableSet *viewControllers = [NSMutableSet set];
    if (self.presentedViewController) {
        [viewControllers addObjectsFromArray:[self.presentedViewController wb_existingViewControllersOfClass:cls]];
    }
    if ([self isKindOfClass:UINavigationController.class]) {
        [viewControllers addObjectsFromArray:[((UINavigationController *)self).visibleViewController wb_existingViewControllersOfClass:cls]];
    }
    if ([self isKindOfClass:UITabBarController.class]) {
        [viewControllers addObjectsFromArray:[((UITabBarController *)self).selectedViewController wb_existingViewControllersOfClass:cls]];
    }
    if ([self isKindOfClass:cls]) {
        [viewControllers addObject:self];
    }
    return viewControllers.allObjects;
}

+ (NSArray <UIViewController *>*)wb_appearanceUpdatingViewControllersOfClass:(Class)cls {
    NSMutableArray *viewControllers = [NSMutableArray array];
    [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (window.rootViewController) {
            [viewControllers addObjectsFromArray:[window.rootViewController wb_existingViewControllersOfClass:cls]];
        }
    }];
    return viewControllers;
}

+ (NSArray <UITabBarController *>*)wb_appearanceUpdatingTabBarControllers {
    return (NSArray <UITabBarController *>*)[self wb_appearanceUpdatingViewControllersOfClass:UITabBarController.class];
}

@end


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


@implementation UIViewController (WBTransition)

- (BOOL)wb_isModal {
    NSArray *vcArray = self.navigationController.viewControllers;
    if (vcArray.count > 0 && [vcArray firstObject] != self) {
        return NO;
    }else if (self.presentingViewController != nil) {
        return YES;
    }else if (self.navigationController.presentingViewController.presentedViewController == self.navigationController) {
        return YES;
    }else if ([self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]]) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)wb_haveNavigationVc {
    return self.navigationController ? YES : NO;
}

- (void)wb_pushVcAnimated:(UIViewController *)vc {
    if ([self wb_haveNavigationVc]) {
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }else {
        NSLog(@"当前控制器没有导航控制器！");
    }
}

- (void)wb_popVcAnimated {
    if ([self wb_haveNavigationVc]) {
         [self.navigationController popViewControllerAnimated:YES];
    }else {
        NSLog(@"当前控制器没有导航控制器！");
    }
}

- (void)wb_popToVcAnimated:(UIViewController *)vc {
    if ([self wb_haveNavigationVc]) {
        [self.navigationController popToViewController:vc
                                              animated:YES];
    }else {
        NSLog(@"当前控制器没有导航控制器！");
    }
    
}

- (void)wb_popToRootVcAnimated {
    if ([self wb_haveNavigationVc]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        NSLog(@"当前控制器没有导航控制器！");
    }
}

- (void)wb_presentVcAnimated:(UIViewController *)vc {
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)wb_presentVcAnimated:(UIViewController *)vc
                  completion:(void (^)(void))completion {
    [self presentViewController:vc
                       animated:YES
                     completion:completion];
}

- (void)wb_dismissVcAnimated {
    if ([self wb_isModal]) {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }else {
        NSLog(@"当前控制器不是模态切换！");
    }
}

- (void)wb_dismissVcAnimatedCompletion:(void (^)(void))completion {
    if ([self wb_isModal]) {
        [self dismissViewControllerAnimated:YES
                                 completion:completion];
    }else {
        NSLog(@"当前控制器不是模态切换！");
    }
}

@end
