//
//  UIView+WBCoreAnimation.h
//  WBCategories
//
//  Created by Admin on 2018/2/6.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WBCoreAnimation)

#pragma mark ------ < Protpery > ------
/**
 Animation complete callback.
 */
@property(nonatomic,copy)void(^completeBlock)(void);

#pragma mark ------ < Animation > ------
/**
 *  kCATransitionFade:交叉淡化过渡
 *
 *  @param duration 时间
 */
- (void)wb_crossfadeWithDuration:(NSTimeInterval)duration;

/**
 kCATransitionFade:交叉淡化过渡

 @param duration 动画时长
 @param completion completionCallbBack
 */
- (void)wb_crossfadeWithDuration:(NSTimeInterval)duration
                      completion:(void (^)(void))completion;

/**
 Left and right shake animation.

 @param duration 动画时长
 */
- (void)wb_shakeAnimationWithDuration:(NSTimeInterval)duration;

/**
 Left and right shake animation. Duration:0.08f;
 */
- (void)wb_shakeAnimation;

/**
 Praise animation
 */
- (void)wb_likeAnimation;

/**
 Spring animation.

 @param duration 动画时长
 */
- (void)wb_springAnimation:(NSTimeInterval)duration;

/**
 Parabola animation.

 @param start start point
 @param end end point
 @param height height value
 @param duration time
 @param completedBlock callback
 */
- (void)wb_throwFrom:(CGPoint)start
                  to:(CGPoint)end
              height:(CGFloat)height
            duration:(CGFloat)duration
      completedBlock:(void(^)(void))completedBlock;


@end
