//
//  UINavigationController+WBStatusBarStyle.h
//  WBManageStatusBarStyleDemo
//
//  Created by 文波 on 2018/7/26.
//  Copyright © 2018年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (WBStatusBarStyle)

/**
 在AppDelegate配置全局样式

 @param statusBarStyle 状态栏样式
 */
+ (void)wb_setDefaultStatusBarStyle:(UIStatusBarStyle)statusBarStyle;

@end

@interface UIViewController (WBStatusBarStyle)

/**
 配置单个控制器状态栏样式
 */
@property (nonatomic, assign) UIStatusBarStyle wb_statusBarStyle;

@end
