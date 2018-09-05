//
//  UIView+WB_Animation.h
//  UIViewUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WBBasicAnimation) 

/**
 Animation complete callback.
 */
@property(nonatomic,copy)void(^completeBlock)(void);

/**
 *  淡出动画
 *
 *  @param duration 动画时间
 */
- (void)wb_fadeInWithDuration:(NSTimeInterval)duration;
- (void)wb_fadeIn;

/**
 *  淡出动画
 *
 *  @param duration 动画时间
 */
- (void)wb_fadeOutWithDuration:(NSTimeInterval)duration;
- (void)wb_fadeOut;

/**
 *  淡出并移除视图
 *
 *  @param duration 动画时间
 */
- (void)wb_fadeOutAndRemoveFromSuperViewWithDuration:(NSTimeInterval)duration;
- (void)wb_fadeOutAndRemoveFromSuperView;

/**
 *  Z轴翻转动画 180°
 *
 */
- (void)wb_transZWithDegree:(CGFloat)degree
                   duration:(NSTimeInterval)duration;

@end
