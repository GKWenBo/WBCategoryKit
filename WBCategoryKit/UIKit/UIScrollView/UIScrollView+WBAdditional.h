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

/// 判断UIScrollView是否已经处于顶部（当UIScrollView内容不够多不可滚动时，也认为是在顶部）
@property(nonatomic, assign, readonly) BOOL wb_alreadyAtTop;

/// 判断UIScrollView是否已经处于底部（当UIScrollView内容不够多不可滚动时，也认为是在底部）
@property(nonatomic, assign, readonly) BOOL wb_alreadyAtBottom;

/// UIScrollView 的真正 inset，在 iOS11 以后需要用到 adjustedContentInset 而在 iOS11 以前只需要用 contentInset
@property(nonatomic, assign, readonly) UIEdgeInsets wb_contentInset;

/// 滚动进度
@property (nonatomic, assign, readonly) CGFloat wb_scrollRatio;

/**
 UIScrollView 默认的 contentInset，会自动将 contentInset 和 scrollIndicatorInsets 都设置为这个值并且调用一次 wb_scrollToTopUponContentInsetTopChange 设置默认的 contentOffset，一般用于 UIScrollViewContentInsetAdjustmentNever 的列表。
 */
@property(nonatomic, assign) UIEdgeInsets wb_initialContentInset;

/**
 * 判断当前的scrollView内容是否足够滚动
 * @warning 避免与<i>scrollEnabled</i>混淆
 */
- (BOOL)wb_canScroll;

/**
 * 不管当前scrollView是否可滚动，直接将其滚动到最顶部
 * @param force 是否无视[self wb_canScroll]而强制滚动
 * @param animated 是否用动画表现
 */
- (void)wb_scrollToTopForce:(BOOL)force
                   animated:(BOOL)animated;

// 立即停止滚动，用于那种手指已经离开屏幕但列表还在滚动的情况。
- (void)wb_stopDeceleratingIfNeeded;

/**
 滚到列表顶部，但如果 contentInset.top 与上一次相同则不会执行滚动操作，通常用于 UIScrollViewContentInsetAdjustmentNever 的 scrollView 设置完业务的 contentInset 后将列表滚到顶部。特别地，对于 UITableView，建议使用 wb_initialContentInset。
 */
- (void)wb_scrollToTopUponContentInsetTopChange;

/**
 以动画的形式修改 contentInset

 @param contentInset 要修改为的 contentInset
 @param animated 是否要使用动画修改
 */
- (void)wb_setContentInset:(UIEdgeInsets)contentInset
                  animated:(BOOL)animated;

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
