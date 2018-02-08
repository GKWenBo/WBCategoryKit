//
//  UIScrollView+WB_Additional.h
//  👍UIScrollViewUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIScrollView (WBAdditional)

/**
 *  滚动到顶部
 *
 *  @param animated 是否动画
 */
- (void)wb_scrollToTopAnimated:(BOOL)animated;
- (void)wb_scrollToTop;

/**
 *  滚动到底部
 *
 *  @param animated 是否动画
 */
- (void)wb_scrollToBottomAnimated:(BOOL)animated;
- (void)wb_scrollToBottom;

/**
 *  滚动到最左边
 *
 *  @param animated 是否动画
 */
- (void)wb_scrollToLeftAnimated:(BOOL)animated;
- (void)wb_scrollToLeft;

/**
 *  滚动到最右边
 *
 *  @param animated 是否动画
 */
- (void)wb_scrollToRightAnimated:(BOOL)animated;
- (void)wb_scrollToRight;

@end
NS_ASSUME_NONNULL_END
