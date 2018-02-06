//
//  UIViewController+WBTransition.m
//  Demo
//
//  Created by Admin on 2017/11/7.
//  Copyright © 2017年 WMB. All rights reserved.
//

#import "UIViewController+WBTransition.h"

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
    return self.navigationController;
}

- (void)wb_pushVcAnimated:(UIViewController *)vc {
    if ([self wb_haveNavigationVc]) {
        [self.navigationController pushViewController:vc animated:YES];
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
        [self.navigationController popToViewController:vc animated:YES];
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

- (void)wb_presentVcAnimated:(UIViewController *)vc completion:(void (^)(void))completion {
    [self presentViewController:vc animated:YES completion:completion];
}

- (void)wb_dismissVcAnimated {
    if ([self wb_isModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        NSLog(@"当前控制器不是模态切换！");
    }
}

- (void)wb_dismissVcAnimatedCompletion:(void (^)(void))completion {
    if ([self wb_isModal]) {
        [self dismissViewControllerAnimated:YES completion:completion];
    }else {
        NSLog(@"当前控制器不是模态切换！");
    }
}

@end
