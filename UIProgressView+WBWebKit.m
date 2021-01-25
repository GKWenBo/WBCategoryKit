//
//  UIProgressView+WBWebKit.m
//  WBWKWebView
//
//  Created by wenbo on 2021/1/25.
//  Copyright © 2021 wenbo. All rights reserved.
//

#import "UIProgressView+WBWebKit.h"
#import <objc/runtime.h>

static const void *kWBHiddenProgressKey = &kWBHiddenProgressKey;

@implementation UIProgressView (WBWebKit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, @selector(setProgress:animated:));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(wb_setProgress:animated:));
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
        originalMethod = class_getInstanceMethod(self, @selector(setProgress:));
        swizzledMethod = class_getInstanceMethod(self, @selector(wb_setProgress:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)wb_setProgress:(float)progress {
    [self wb_setProgress:progress];
    
    [self wb_checkHiddenWhenProgressApproachFullSize];
}

- (void)wb_setProgress:(float)progress animated:(BOOL)animated {
    [self wb_setProgress:progress animated:animated];
    
    [self wb_checkHiddenWhenProgressApproachFullSize];
}

- (void)wb_checkHiddenWhenProgressApproachFullSize {
    if (!self.wb_hiddenWhenProgressApproachFullSize) return;
    
    if (self.progress < 1) {
        if (self.hidden) self.hidden = NO;
    } else if (self.progress >= 1) {
        [UIView animateWithDuration:0.35 delay:0.15 options:7 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            
            self.progress = 0.0;
            self.alpha = 1.0;
        }];
    }
}

- (void)setWb_hiddenWhenProgressApproachFullSize:(BOOL)wb_hiddenWhenProgressApproachFullSize {
    objc_setAssociatedObject(self, kWBHiddenProgressKey, @(wb_hiddenWhenProgressApproachFullSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wb_hiddenWhenProgressApproachFullSize {
    return [objc_getAssociatedObject(self, kWBHiddenProgressKey) boolValue];
}

@end
