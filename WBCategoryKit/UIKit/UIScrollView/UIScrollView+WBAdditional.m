//
//  UIScrollView+WB_Additional.m
//  👍UIScrollViewUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIScrollView+WBAdditional.h"
#import "objc/runtime.h"
#import "WBCategoryKitCore.h"

@interface UIScrollView ()

@property(nonatomic, assign) CGFloat wbscroll_lastInsetTopWhenScrollToTop;

@end

@implementation UIScrollView (WBAdditional)

// MARK: -------- getter && setter
- (void)setWbscroll_lastInsetTopWhenScrollToTop:(CGFloat)wbscroll_lastInsetTopWhenScrollToTop {
    objc_setAssociatedObject(self, @selector(wbscroll_lastInsetTopWhenScrollToTop), @(wbscroll_lastInsetTopWhenScrollToTop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)wbscroll_lastInsetTopWhenScrollToTop {
    return [objc_getAssociatedObject(self, @selector(wbscroll_lastInsetTopWhenScrollToTop)) floatValue];
}

- (BOOL)wb_alreadyAtTop {
    if (((NSInteger)self.contentOffset.y) == -((NSInteger)self.wb_contentInset.top)) {
        return YES;
    }
    return NO;
}

- (BOOL)wb_alreadyAtBottom {
    if (!self.wb_canScroll) {
        return YES;
    }
    
    if (((NSInteger)self.contentOffset.y) == ((NSInteger)self.contentSize.height + self.wb_contentInset.bottom - CGRectGetHeight(self.bounds))) {
        return YES;
    }
    return NO;
}

- (UIEdgeInsets)wb_contentInset {
    if (@available(iOS 11, *)) {
        return self.adjustedContentInset;
    } else {
        return self.contentInset;
    }
}

static char kAssociatedObjectKey_initialContentInset;
- (void)setWb_initialContentInset:(UIEdgeInsets)wb_initialContentInset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_initialContentInset, [NSValue valueWithUIEdgeInsets:wb_initialContentInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.contentInset = wb_initialContentInset;
    self.scrollIndicatorInsets = wb_initialContentInset;
    
    [self wbscroll_lastInsetTopWhenScrollToTop];
}

- (UIEdgeInsets)wb_initialContentInset {
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_initialContentInset) UIEdgeInsetsValue];
}

- (void)wb_scrollToTopUponContentInsetTopChange {
    if (self.wbscroll_lastInsetTopWhenScrollToTop != self.contentInset.top) {
        [self wb_scrollToTop];
        self.wbscroll_lastInsetTopWhenScrollToTop = self.contentInset.top;
    }
}

- (BOOL)wb_canScroll {
    // 没有高度就不用算了，肯定不可滚动，这里只是做个保护
    if (WBCGSizeIsEmpty(self.bounds.size)) {
        return NO;
    }
    BOOL canVerticalScroll = self.contentSize.height + WBUIEdgeInsetsGetVerticalValue(self.wb_contentInset) > CGRectGetHeight(self.bounds);
    BOOL canHorizontalScoll = self.contentSize.width + WBUIEdgeInsetsGetHorizontalValue(self.wb_contentInset) > CGRectGetWidth(self.bounds);
    return canVerticalScroll || canHorizontalScoll;
}

- (void)wb_stopDeceleratingIfNeeded {
    if (self.decelerating) {
        [self setContentOffset:self.contentOffset animated:NO];
    }
}

- (void)wb_scrollToTopForce:(BOOL)force animated:(BOOL)animated {
    if (force || (!force && [self wb_canScroll])) {
        [self setContentOffset:CGPointMake(-self.wb_contentInset.left, -self.wb_contentInset.top) animated:animated];
    }
}

- (void)wb_setContentInset:(UIEdgeInsets)contentInset
                  animated:(BOOL)animated {
    [UIView animateWithDuration:.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.contentInset = contentInset;
    }
                     completion:nil];
}

/**
 *  滚动到顶部
 *
 *  @param animated 是否动画
 */
- (void)wb_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}
- (void)wb_scrollToTop {
    [self wb_scrollToTopAnimated:NO];
}

/**
 *  滚动到底部
 *
 *  @param animated 是否动画
 */
- (void)wb_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}
- (void)wb_scrollToBottom {
    [self wb_scrollToBottomAnimated:NO];
}

/**
 *  滚动到最左边
 *
 *  @param animated 是否动画
 */
- (void)wb_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)wb_scrollToLeft {
    [self wb_scrollToLeftAnimated:NO];
}

- (void)wb_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}
- (void)wb_scrollToRight {
    [self wb_scrollToRightAnimated:NO];
}
@end
