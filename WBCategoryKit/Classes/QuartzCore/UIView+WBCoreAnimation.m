//
//  UIView+WBCoreAnimation.m
//  WBCategories
//
//  Created by Admin on 2018/2/6.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIView+WBCoreAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const void *kCoreAnimationCompletionKey = &kCoreAnimationCompletionKey;

@interface UIView () <CAAnimationDelegate>

@end


@implementation UIView (WBCoreAnimation)

- (void)wb_crossfadeWithDuration:(NSTimeInterval)duration {
    CATransition *animation = [CATransition animation];
    /**  < 设置动画类型 >  */
    animation.type = kCATransitionFade;
    /**  < 动画时长 >  */
    animation.duration = duration;
    /**  < 动画完成移除动画 >  */
    animation.removedOnCompletion = YES;
    /**  < 添加动画 >  */
    [self.layer addAnimation:animation forKey:nil];
}

- (void)wb_crossfadeWithDuration:(NSTimeInterval)duration
                      completion:(void (^)(void))completion {
    [self wb_crossfadeWithDuration:duration];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)wb_shakeAnimationWithDuration:(NSTimeInterval)duration {
    CALayer* layer = [self layer];
    CGPoint position = [layer position];
    CGPoint from = CGPointMake(position.x - 8.0f, position.y);
    CGPoint to = CGPointMake(position.x + 8.0f, position.y);
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:from]];
    [animation setToValue:[NSValue valueWithCGPoint:to]];
    [animation setAutoreverses:YES];
    [animation setDuration:duration];
    [animation setRepeatCount:3];
    animation.removedOnCompletion = YES;
    [layer addAnimation:animation forKey:nil];
}

- (void)wb_shakeAnimation {
    [self wb_shakeAnimationWithDuration:0.08f];
}

- (void)wb_likeAnimation {
    CAKeyframeAnimation *praiseAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    praiseAnimation.values = @[@(0.1),@(1.0),@(1.5)];
    praiseAnimation.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    praiseAnimation.calculationMode = kCAAnimationLinear;
    praiseAnimation.removedOnCompletion = YES;
    [self.layer addAnimation:praiseAnimation forKey:@"praiseAnimation"];
}

- (void)wb_springAnimation:(NSTimeInterval)duration {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = duration;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    popAnimation.removedOnCompletion = YES;
    [[self layer] addAnimation:popAnimation forKey:nil];
}

- (void)wb_throwFrom:(CGPoint)start
                  to:(CGPoint)end
              height:(CGFloat)height
            duration:(CGFloat)duration
      completedBlock:(void(^)(void))completedBlock {
    self.completeBlock = completedBlock;
    //初始化抛物线path
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat cpx = (start.x + end.x) / 2;
    NSLog(@"最高点为%lf",height);
    CGFloat cpy = height;
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, end.x, end.y);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    CFRelease(path);
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.toValue = [NSNumber numberWithFloat:(CGFloat)((arc4random() % 4) + 4) / 10.0];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.repeatCount = 0;
    groupAnimation.delegate = self;
    groupAnimation.duration = duration;
    groupAnimation.removedOnCompletion = YES;
    groupAnimation.animations = @[scaleAnimation, animation];
    [self.layer addAnimation:groupAnimation forKey:@"position scale"];
}

- (void)wb_rotateXWithAngle:(CGFloat)angle
                   diretion:(WBRotateDiretion)diretion
                   duration:(NSTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation
                                   animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    switch (diretion) {
        case WBRotateXDiretion:
            animation.toValue = [NSValue valueWithCATransform3D:
                                 CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0)];
            break;
        case WBRotateYDiretion:
            animation.toValue = [NSValue valueWithCATransform3D:
                                 CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0)];
            break;
        case WBRotateZDiretion:
            animation.toValue = [NSValue valueWithCATransform3D:
                                 CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)];
            break;
        default:
            break;
    }
    animation.duration = duration;
    [self.layer addAnimation:animation
                      forKey:nil];
}

#pragma mark ------ < Getter And Setter > ------
- (void)setCompleteBlock:(void (^)(void))completeBlock {
    objc_setAssociatedObject(self, kCoreAnimationCompletionKey, completeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))completeBlock {
    return objc_getAssociatedObject(self, kCoreAnimationCompletionKey);
}

#pragma mark ------ < CAAnimationDelegate > ------
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.completeBlock && flag) {
        self.completeBlock();
    }
}
@end
