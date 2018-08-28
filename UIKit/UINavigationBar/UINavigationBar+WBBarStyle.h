//
//  UINavigationBar+WBBarStyle.h
//  WBManageStatusBarStyleDemo
//
//  Created by Mr_Lucky on 2018/8/28.
//  Copyright © 2018年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (WBBarStyle)

/**
 在AppDelegate配置全局样式
 
 @param statusBarStyle 状态栏样式
 */
+ (void)wb_setDefaultStatusBarStyle:(UIStatusBarStyle)statusBarStyle;

@end

@interface UIViewController (WBBarStyle)

/**
 配置单个控制器状态栏样式
 */
@property (nonatomic, assign) UIStatusBarStyle wb_statusBarStyle;

@end
