//
//  UIView+WBRecursion.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WBSubviewBlock)(UIView *subview);
typedef void(^WBSuperviewBlock)(UIView *spuerview);

@interface UIView (WBRecursion)

/**
 Find subview.

 @param recurse call back block
 @return UIView
 */
- (UIView *)wb_findViewRecursively:(BOOL(^)(UIView *subView, BOOL *stop))recurse;

/**
 Find all subviews.

 @param block call back block.
 */
- (void)wb_runBlockOnAllSubviews:(WBSubviewBlock)block;

/**
 Find all superviews

 @param block call back block.
 */
- (void)wb_runBlockOnAllSuperviews:(WBSuperviewBlock)block;

/**
 Enable control evnets.
 */
- (void)wb_enableAllControlsInViewHierarchy;

/**
 Disable control evnets.
 */
- (void)wb_disableAllControlsInViewHierarchy;

@end
