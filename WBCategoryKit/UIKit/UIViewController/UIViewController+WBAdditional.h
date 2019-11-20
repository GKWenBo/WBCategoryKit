//
//  UIViewController+WBAdditional.h
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WBAdditional)

/**
 Hide navigaiton back button.
 */
- (void)wb_hideBackButton;

@end

@interface UIViewController (WBRemoveTabbarButton)

///  Remove system tabbarButton
- (void)wb_removeTabbarButton;

@end


@interface UIViewController (WBTransition)

/**
 Check if view controller is presented modally, or pushed on a navigation stack

 @return YES/NO
 */
- (BOOL)wb_isModal;

/**
 Check if have navigationcontroller

 @return YES/NO
 */
- (BOOL)wb_haveNavigationVc;

/**
 Push to vc with animation

 @param vc target vc
 */
- (void)wb_pushVcAnimated:(UIViewController *)vc;

/**
 Returns the popped controller
 */
- (void)wb_popVcAnimated;

/**
 Pops view controllers until the one specified is on top. Returns the popped controllers

 @param vc vc description
 */
- (void)wb_popToVcAnimated:(UIViewController *)vc;

/**
 ops until there's only a single view controller left on the stack. Returns the popped controllers.
 */
- (void)wb_popToRootVcAnimated;

/**
 模态切换

 @param vc vc description
 */
- (void)wb_presentVcAnimated:(UIViewController *)vc;

/**
 模态切换

 @param vc target vc
 @param completion 完成回调
 */
- (void)wb_presentVcAnimated:(UIViewController *)vc
                  completion:(void (^) (void))completion;

/**
 Modal dismiss.
 */
- (void)wb_dismissVcAnimated;

/**
 Modal dismiss.

 @param completion 完成回调
 */
- (void)wb_dismissVcAnimatedCompletion:(void (^) (void))completion;

@end
