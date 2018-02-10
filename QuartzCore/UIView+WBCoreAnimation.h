//
//  UIView+WBCoreAnimation.h
//  WBCategories
//
//  Created by Admin on 2018/2/6.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBRotateDiretion) {
    WBRotateXDiretion,  /** << X轴 > */
    WBRotateYDiretion,  /** << Y轴 > */
    WBRotateZDiretion   /** << Z轴 > */
};

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

/**
 Rotate around x axis.

 @param angle angle
 @param diretion The first is the angle in radians the other 3 parameters are the axis (x, y, z). So for example if you want to rotate 180 degrees around the z axis just call the function like this:CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0)
 @param duration time
 */
- (void)wb_rotateXWithAngle:(CGFloat)angle
                   diretion:(WBRotateDiretion)diretion
                   duration:(NSTimeInterval)duration;



@end
