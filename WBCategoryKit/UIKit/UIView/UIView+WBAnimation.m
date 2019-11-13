//
//  UIView+WBAnimation.m
//  Pods
//
//  Created by 文波 on 2019/11/13.
//

#import "UIView+WBAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const void *UtilityKey = &UtilityKey;

@interface UIView () <CAAnimationDelegate>

@end

@implementation UIView (WBAnimation)

- (void)shake {
    [self shake:5
      withDelta:5
          speed:0.03];
}

- (void)shake:(int)times
    withDelta:(CGFloat)delta {
    [self shake:times
      withDelta:delta
     completion:nil];
}

- (void)shake:(int)times
    withDelta:(CGFloat)delta
   completion:(nullable void (^)(void))handler {
    [self shake:times
      withDelta:delta
          speed:0.03
     completion:handler];
}

- (void)shake:(int)times
    withDelta:(CGFloat)delta
        speed:(NSTimeInterval)interval {
    [self shake:times
      withDelta:delta
          speed:interval
     completion:nil];
}

- (void)shake:(int)times
    withDelta:(CGFloat)delta
        speed:(NSTimeInterval)interval completion:(nullable void (^)(void))handler {
    [self shake:times
      withDelta:delta
          speed:interval
 shakeDirection:ShakeDirectionHorizontal
     completion:handler];
}

- (void)shake:(int)times
    withDelta:(CGFloat)delta
        speed:(NSTimeInterval)interval
shakeDirection:(ShakeDirection)shakeDirection {
    [self shake:times
      withDelta:delta
          speed:interval
 shakeDirection:shakeDirection
     completion:nil];
}

- (void)shake:(int)times
    withDelta:(CGFloat)delta
        speed:(NSTimeInterval)interval
shakeDirection:(ShakeDirection)shakeDirection
   completion:(nullable void (^)(void))completion {
    [self _shake:times
       direction:1
    currentTimes:0
       withDelta:delta
           speed:interval
  shakeDirection:shakeDirection
      completion:completion];
}

- (void)_shake:(int)times
     direction:(int)direction
  currentTimes:(int)current
     withDelta:(CGFloat)delta
         speed:(NSTimeInterval)interval
shakeDirection:(ShakeDirection)shakeDirection
    completion:(void (^)(void))completionHandler {
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:interval animations:^{
        switch (shakeDirection) {
            case ShakeDirectionVertical:
                weakSelf.layer.affineTransform = CGAffineTransformMakeTranslation(0, delta * direction);
                break;
            case ShakeDirectionRotation:
                weakSelf.layer.affineTransform = CGAffineTransformMakeRotation(M_PI * delta / 1000.0f * direction);
                break;
            case ShakeDirectionHorizontal:
                weakSelf.layer.affineTransform = CGAffineTransformMakeTranslation(delta * direction, 0);
            default:
                break;
        }
    } completion:^(BOOL finished) {
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                weakSelf.layer.affineTransform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                if (completionHandler != nil) {
                    completionHandler();
                }
            }];
            return;
        }
        [weakSelf _shake:times
               direction:direction * -1
            currentTimes:current + 1
               withDelta:delta
                   speed:interval
          shakeDirection:shakeDirection
              completion:completionHandler];
    }];
}

- (void)setCompleteBlock:(void (^)(void))completeBlock
{
    objc_setAssociatedObject(self, &UtilityKey, completeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(void))completeBlock
{
    return objc_getAssociatedObject(self, UtilityKey);
}

// MARK: -------- Basic Animation

- (void)wb_fadeInWithDuration:(NSTimeInterval)duration {
    UIView *view = self;
    view.alpha = 0.f;
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        view.alpha = 1.0f;
    } completion:nil];
}

- (void)wb_fadeIn {
    [self wb_fadeInWithDuration:0.2f];
}

/**
 *  淡出动画
 *
 *  @param duration 动画时间
 */
- (void)wb_fadeOutWithDuration:(NSTimeInterval)duration {
    UIView *view = self;
    view.alpha = 1.f;
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        view.alpha = 0.0f;
    } completion:nil];
}
- (void)wb_fadeOut {
    [self wb_fadeOutWithDuration:0.2f];
}

/**
 *  淡出并移除视图
 *
 *  @param duration 动画时间
 */
- (void)wb_fadeOutAndRemoveFromSuperViewWithDuration:(NSTimeInterval)duration {
    UIView *view = self;
    view.alpha = 1.f;
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)wb_fadeOutAndRemoveFromSuperView {
    [self wb_fadeOutAndRemoveFromSuperViewWithDuration:0.2f];
}

- (void)wb_transZWithDegree:(CGFloat)degree
                   duration:(NSTimeInterval)durationn {
    [UIView animateWithDuration:durationn
                     animations:^{
        self.layer.transform = CATransform3DMakeRotation(degree, 0, 1, 0);
    }];
}

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

#pragma mark ------ < CAAnimationDelegate > ------
- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag {
    if (self.completeBlock && flag) {
        self.completeBlock();
    }
}

@end
