//
//  UIViewController+WBAdditional.h
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WBAdditional)

/// Hide navigaiton back button.
- (void)wb_hideBackButton;

/// 获取class存在的控制器
/// @param cls 要获取的class
- (NSArray <UIViewController *>*)wb_existingViewControllersOfClass:(Class)cls;

/// 获取需要更新的控制器
/// @param cls cls description
+ (NSArray <UIViewController *>*)wb_appearanceUpdatingViewControllersOfClass:(Class)cls;

/// 获取UITabBarController
+ (NSArray <UITabBarController *>*)wb_appearanceUpdatingTabBarControllers;

@end

@interface UIViewController (WBRemoveTabbarButton)

///  Remove system tabbarButton
- (void)wb_removeTabbarButton;

@end


@interface UIViewController (WBTransition)

/// Check if view controller is presented modally, or pushed on a navigation stack
- (BOOL)wb_isModal;

/// Check if have navigationcontroller
- (BOOL)wb_haveNavigationVc;

/// Push to vc with animation
/// @param vc target vc
- (void)wb_pushVcAnimated:(UIViewController *)vc;

/// Returns the popped controller
- (void)wb_popVcAnimated;

/// Pops view controllers until the one specified is on top. Returns the popped controllers
/// @param vc vc description
- (void)wb_popToVcAnimated:(UIViewController *)vc;

/// ops until there's only a single view controller left on the stack. Returns the popped controllers.
- (void)wb_popToRootVcAnimated;

/// 模态切换
/// @param vc vc description
- (void)wb_presentVcAnimated:(UIViewController *)vc;

/// 模态切换
/// @param vc target vc
/// @param completion 完成回调
- (void)wb_presentVcAnimated:(UIViewController *)vc
                  completion:(void (^) (void))completion;

/// Modal dismiss.
- (void)wb_dismissVcAnimated;

/// Modal dismiss.
/// @param completion 完成回调
- (void)wb_dismissVcAnimatedCompletion:(void (^) (void))completion;

@end
