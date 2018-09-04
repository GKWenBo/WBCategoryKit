//
//  UIViewController+WBTransition.h
//  Demo
//
//  Created by Admin on 2017/11/7.
//  Copyright © 2017年 WMB. All rights reserved.
//

#import <UIKit/UIKit.h>

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
