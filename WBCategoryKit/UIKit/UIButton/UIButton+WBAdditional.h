//
//  UIButton+WB_Additional.h
//  WB_UIButtonManager
//
//  Created by WMB on 2017/6/1.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WBAdditional)

#pragma mark --------  添加点击事件  --------
/// 按钮添加点击事件
/// @param target 监听对象
/// @param action 监听事件
- (void)wb_addTarget:(id)target
              action:(SEL)action;

#pragma mark --------  快速创建按钮  --------
/// 创建按钮
/// @param title 标题
/// @param font 字体
/// @param titleColor 标题颜色
+ (instancetype)wb_buttonWithTitle:(NSString *)title
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor;
/// 创建按钮
/// @param title 标题
/// @param fontSize 字体大小
/// @param titleColor 标题颜色
/// @param backgroundImage 监听
/// @param target 背景图片
/// @param action 按钮事件
+ (UIButton *)wb_createButtonWithTitle:(NSString *)title
                              fontSize:(CGFloat)fontSize
                            titleColor:(UIColor *)titleColor
                       backgroundImage:(UIImage *)backgroundImage
                                target:(id)target
                                action:(SEL)action;

#pragma mark --------  根据颜色设置背景图片  --------
/// 根据颜色设置背景图片
/// @param color  颜色
/// @param forState 按钮状态
- (void)wb_setBackgroundImageWithColor:(UIColor *)color
                              forState:(UIControlState)forState;


@end
