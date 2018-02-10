//
//  UIView+WBShake.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

/**  <
 GitHub：https://github.com/andreamazz/UIView-Shake
 Author：andreamazz
 >  */

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

@interface UIView (WBShake)

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

@end
