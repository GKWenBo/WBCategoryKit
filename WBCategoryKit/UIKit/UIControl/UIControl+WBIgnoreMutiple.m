//
//  UIControl+WBIgnoreMutiple.m
//  WBCategories
//
//  Created by wenbo on 2018/5/14.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIControl+WBIgnoreMutiple.h"
#import <objc/runtime.h>

static const void *kAcceptTimeIntervalKey = &kAcceptTimeIntervalKey;
static const void *kIgnoreEventKey = &kIgnoreEventKey;

@implementation UIControl (WBIgnoreMutiple)

+ (void)load {
    Method originMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method newMethod = class_getInstanceMethod(self, @selector(_wb_sendAction:to:forEvent:));
    method_exchangeImplementations(originMethod, newMethod);
}

#pragma mark < getter && setter >
- (void)setWb_ignoreEvent:(BOOL)wb_ignoreEvent {
    objc_setAssociatedObject(self, kIgnoreEventKey, @(wb_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setWb_acceptEventTimeInterval:(NSTimeInterval)wb_acceptEventTimeInterval {
    objc_setAssociatedObject(self, kAcceptTimeIntervalKey, @(wb_acceptEventTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wb_ignoreEvent {
    return [objc_getAssociatedObject(self, kIgnoreEventKey) boolValue];
}

- (NSTimeInterval)wb_acceptEventTimeInterval {
    return [objc_getAssociatedObject(self, kAcceptTimeIntervalKey) doubleValue];
}

#pragma mark < method >
- (void)_wb_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.wb_ignoreEvent) {
        return;
    }
    if (self.wb_acceptEventTimeInterval > 0) {
        self.wb_ignoreEvent = YES;
        [self performSelector:@selector(setWb_ignoreEvent:) withObject:@(NO) afterDelay:self.wb_acceptEventTimeInterval];
    }
    [self _wb_sendAction:action to:target forEvent:event];
}

@end
