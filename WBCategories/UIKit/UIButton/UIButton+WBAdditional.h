//
//  UIButton+WB_Additional.h
//  WB_UIButtonManager
//
//  Created by WMB on 2017/6/1.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonTouchBlock)(NSInteger tag);

@interface UIButton (WBAdditional)

#pragma mark --------  添加点击事件  --------
#pragma mark
/**
 *  按钮添加点击事件
 *
 *  @param target 监听对象
 *  @param action 监听事件
 */
- (void)wb_addTarget:(id)target
                        action:(SEL)action;

#pragma mark --------  点击Block回调  --------
#pragma mark
- (void)wb_addActionHandler:(ButtonTouchBlock)touchHandler;

#pragma mark --------  快速创建按钮  --------
#pragma mark
/**
 *  创建按钮
 *
 *  @param title 标题
 *  @param fontSize 字体大小
 *  @param titleColor 标题颜色
 *  @param backgroundImage 背景图片
 *  @param target 监听
 *  @param action 按钮事件
 */
+ (UIButton *)wb_createButtonWithTitle:(NSString *)title
                              fontSize:(CGFloat)fontSize
                            titleColor:(UIColor *)titleColor
                       backgroundImage:(UIImage *)backgroundImage
                                target:(id)target
                                action:(SEL)action;

#pragma mark --------  根据颜色设置背景图片  --------
#pragma mark
/**
 *  根据颜色设置背景图片
 *
 *  @param color 颜色
 *  @param forState 按钮状态
 */
- (void)wb_setBackgroundImageWithColor:(UIColor *)color
                              forState:(UIControlState)forState;

#pragma mark --------  按钮倒计时  --------
#pragma mark
/**
 *  设置按钮倒计时
 *
 *  @param timeout 倒计时时间
 *  @param tittle 按钮标题
 *  @param waitTittle 等待标题
 */
- (void)wb_startTime:(NSInteger )timeout
               title:(NSString *)tittle
          waitTittle:(NSString *)waitTittle;
/**
 *  设置按钮倒计时
 *
 *  @param time 倒计时时间
 *  @param button 对象按钮
 */
+ (void)wb_showCountDownTime:(NSUInteger)time
                    inButton:(UIButton *)button;

@end
