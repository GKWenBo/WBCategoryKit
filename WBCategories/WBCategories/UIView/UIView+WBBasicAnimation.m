//
//  UIView+WB_Animation.m
//  UIViewUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIView+WBBasicAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const void *UtilityKey = &UtilityKey;

@implementation UIView (WBBasicAnimation)

- (void)setCompleteBlock:(void (^)(void))completeBlock
{
    objc_setAssociatedObject(self, &UtilityKey, completeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(void))completeBlock
{
    return objc_getAssociatedObject(self, UtilityKey);
}

- (void)wb_fadeInWithDuration:(NSTimeInterval)duration {
    UIView *view = self;
    view.alpha = 0.f;
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
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
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)wb_fadeOutAndRemoveFromSuperView {
    [self wb_fadeOutAndRemoveFromSuperViewWithDuration:0.2f];
}


- (void)wb_trans180DegreeAnimation {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//    }];
    
        CABasicAnimation *animation = [CABasicAnimation
                                       animationWithKeyPath: @"transform" ];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
        //围绕Z轴旋转，垂直与屏幕
        animation.toValue = [NSValue valueWithCATransform3D:
    
                             CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.f) ];
        animation.duration = 0.4;
    
        [self.layer addAnimation:animation forKey:nil];
}

@end
