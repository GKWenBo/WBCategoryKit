//
//  UIScrollView+WB_Additional.m
//  👍UIScrollViewUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIScrollView+WBAdditional.h"

@implementation UIScrollView (WBAdditional)

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
    [self wb_scrollToTopAnimated:YES];
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
    
    [self wb_scrollToBottomAnimated:YES];
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
    [self wb_scrollToLeftAnimated:YES];
}

- (void)wb_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}
- (void)wb_scrollToRight {
    [self wb_scrollToRightAnimated:YES];
}
@end
