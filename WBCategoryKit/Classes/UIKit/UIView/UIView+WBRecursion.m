//
//  UIView+WBRecursion.m
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIView+WBRecursion.h"

@implementation UIView (WBRecursion)

- (UIView *)wb_findViewRecursively:(BOOL(^)(UIView *subView,BOOL *stop))recurse{
    for (UIView *view in self.subviews) {
        BOOL stop = NO;
        if (recurse(view, &stop)) {
            return [view wb_findViewRecursively:recurse];
        }else if (stop) {
            return view;
        }
    }
    return nil;
}

- (void)wb_runBlockOnAllSubviews:(WBSubviewBlock)block {
    block(self);
    for (UIView *view in self.subviews) {
        [view wb_runBlockOnAllSubviews:block];
    }
}

- (void)wb_runBlockOnAllSuperviews:(WBSuperviewBlock)block {
    block(self);
    if (self.superview) {
        [self.superview wb_runBlockOnAllSuperviews:block];
    }
}

- (void)wb_enableAllControlsInViewHierarchy {
    [self wb_runBlockOnAllSubviews:^(UIView *subview) {
        if ([subview isKindOfClass:[UIControl class]])
        {
            [(UIControl *)subview setEnabled:YES];
        }
        else if ([subview isKindOfClass:[UITextView class]])
        {
            [(UITextView *)subview setEditable:YES];
        }
    }];
}

- (void)wb_disableAllControlsInViewHierarchy {
    [self wb_runBlockOnAllSubviews:^(UIView *subview) {
        if ([subview isKindOfClass:[UIControl class]])
        {
            [(UIControl *)subview setEnabled:NO];
        }
        else if ([subview isKindOfClass:[UITextView class]])
        {
            [(UITextView *)subview setEditable:NO];
        }
    }];
}

@end
