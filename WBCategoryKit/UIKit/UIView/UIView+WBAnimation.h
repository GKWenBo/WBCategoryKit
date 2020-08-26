//
//  UIView+WBAnimation.h
//  Pods
//
//  Created by 文波 on 2019/11/13.
//

#import <UIKit/UIKit.h>

/** @enum ShakeDirection
 *
 * Enum that specifies the direction of the shake
 */
typedef NS_ENUM(NSInteger, ShakeDirection) {
    /** Shake left and right */
    ShakeDirectionHorizontal,
    /** Shake up and down */
    ShakeDirectionVertical,
    /** Shake rotation */
    ShakeDirectionRotation
};

typedef NS_ENUM(NSInteger, WBRotateDiretion) {
    WBRotateXDiretion,  /** << X轴 > */
    WBRotateYDiretion,  /** << Y轴 > */
    WBRotateZDiretion   /** << Z轴 > */
};


NS_ASSUME_NONNULL_BEGIN

@interface UIView (WBAnimation)

/**-----------------------------------------------------------------------------
 * @name UIView+Shake
 * -----------------------------------------------------------------------------
 */

/** Shake the UIView
 *
 * Shake the view a default number of times
 */
- (void)shake;

/** Shake the UIView
 *
 * Shake the view a given number of times
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 */
- (void)shake:(int)times
    withDelta:(CGFloat)delta;

/** Shake the UIView
 *
 * Shake the view a given number of times
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param handler A block object to be executed when the shake sequence ends
 */
- (void)shake:(int)times
    withDelta:(CGFloat)delta
   completion:(nullable void (^)(void))handler;

/** Shake the UIView at a custom speed
 *
 * Shake the view a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 */
- (void)shake:(int)times
    withDelta:(CGFloat)delta
        speed:(NSTimeInterval)interval;

/** Shake the UIView at a custom speed
 *
 * Shake the view a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param handler A block object to be executed when the shake sequence ends
 */
- (void)shake:(int)times withDelta:(CGFloat)delta
        speed:(NSTimeInterval)interval
   completion:(nullable void (^)(void))handler;

/** Shake the UIView at a custom speed
 *
 * Shake the view a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param shakeDirection of the shake
 */
- (void)shake:(int)times
    withDelta:(CGFloat)delta
        speed:(NSTimeInterval)interval
shakeDirection:(ShakeDirection)shakeDirection;

/** Shake the UIView at a custom speed
 *
 * Shake the view a given number of times with a given speed, with a completion handler
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param shakeDirection of the shake
 * @param completion to be called when the view is done shaking
 */
- (void)shake:(int)times
    withDelta:(CGFloat)delta
        speed:(NSTimeInterval)interval
shakeDirection:(ShakeDirection)shakeDirection
   completion:(nullable void (^)(void))completion;

// MARK: -------- Basic Animation
/**
 Animation complete callback.
 */
@property(nonatomic, copy) void(^completeBlock)(void);

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

NS_ASSUME_NONNULL_END
