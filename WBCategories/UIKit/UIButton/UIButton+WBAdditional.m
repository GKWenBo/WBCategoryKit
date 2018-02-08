//
//  UIButton+WB_Additional.m
//  WB_UIButtonManager
//
//  Created by WMB on 2017/6/1.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIButton+WBAdditional.h"


@implementation UIButton (WBAdditional)

- (void)wb_addTarget:(id)target
              action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.exclusiveTouch = YES;
}

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
                                action:(SEL)action {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark --------  根据颜色设置背景图片  --------
#pragma mark
/**
 *  根据颜色设置背景图片
 *
 *  @param color 颜色
 *  @param forState 按钮状态
 */
- (void)wb_setBackgroundImageWithColor:(UIColor *)color
                              forState:(UIControlState)forState {
    [self setBackgroundImage:[UIButton imageWithColor:color] forState:forState];
}

#pragma mark --------  private method  --------
#pragma mark
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
