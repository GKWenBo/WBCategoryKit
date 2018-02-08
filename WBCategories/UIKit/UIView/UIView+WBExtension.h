//
//  UIView+WB_Extension.h
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/15.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WBRectCornerType) {
    WBRectCornerTop,
    WBRectCornerLeft,
    WBRectCornerRight,
    WBRectCornerBottom,
    WBRectCornerAll
};

NS_ASSUME_NONNULL_BEGIN
@interface UIView (WBExtension)

#pragma mark -- Event
#pragma mark
/**
 *  view 添加点击事件
 *
 *  @param target 目标
 *  @param action 事件
 */
- (void)wb_addTapGestureTarget:(id)target
                        action:(SEL)action;

#pragma mark -- Border
#pragma mark
/**
 *  view 添加边框
 *
 *  @param color 边框颜色
 *  @param borderWidth 宽度
 *  @param cornerRadius 圆角
 */
- (void)wb_addBorderWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth
                 cornerRadius:(CGFloat)cornerRadius;
/**
 *  添加边框(默认圆角为4)
 *
 *  @param color 边框颜色
 */
- (void)wb_addBorderAndCornerRadiusWithColor:(UIColor *)color;
/**
 *  添加边框
 *
 *  @param color 边框颜色
 *  @param borderWidth 边框宽度
 */
- (void)wb_addBorderWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth;

#pragma mark -- CornerRadius
#pragma mark
/**
 *  设置圆角
 *
 *  @param cornerRadius 圆角大小
 */
- (void)wb_setCornerRadius:(CGFloat)cornerRadius;

/**
 *  视图切成圆
 *
 */
- (void)wb_setCircleCornerRadius;

/**
 *  为某个方向添加指定圆角大小
 *
 *  @param rectCorner
           UIRectCornerTopLeft
           UIRectCornerTopRight
           UIRectCornerBottomLeft
           UIRectCornerBottomRight
           UIRectCornerAllCorners
 *  @param cornerRadius 圆角size
 */
- (void)wb_setBezierCornerRadiusByRoundingCorners:(WBRectCornerType)rectCorner
                                     cornerRadius:(CGFloat)cornerRadius;

#pragma mark --------  父视图  --------
#pragma mark
/**  父视图  */
- (NSArray *)superviews;

#pragma mark --------  添加视图到Window上  --------
#pragma mark
- (void)wb_addToWindow;

@end
NS_ASSUME_NONNULL_END
