//
//  UIButton+WB_AdjustPosition.h
//  WB_UIButtonManager
//
//  Created by WMB on 2017/6/1.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WBAdjustPosition)

/**
 *  上下居中，图片在上，文字在下
 *
 *  @param spacing 间隔 默认6.0
 */
- (void)wb_verticalCenterImageAndTitle:(CGFloat)spacing;
- (void)wb_verticalCenterImageAndTitle;


/**
 *  按钮图片垂直居中显示(法2)
 *  @param spacing 间隔
 *
 */
- (void)wb_middleAlignButtonWithSpacing:(CGFloat)spacing;


/**
 *  左右居中，文字在左，图片在右
 *
 *  @param spacing 间隔 默认6.0
 */
- (void)wb_horizontalCenterTitleAndImage:(CGFloat)spacing;
- (void)wb_horizontalCenterTitleAndImage;

/**
 *  左右居中，图片在左，文字在右
 *
 *  @param spacing 间隔 默认6.0
 */
- (void)wb_horizontalCenterImageAndTitle:(CGFloat)spacing;
- (void)wb_horizontalCenterImageAndTitle;

/**
 *  文字居中，图片在左边
 *
 *  @param spacing 间隔 默认6.0
 */
- (void)wb_horizontalCenterTitleAndImageLeft:(CGFloat)spacing;
- (void)wb_horizontalCenterTitleAndImageLeft;

/**
 *  文字居中，图片在右边
 *
 *  @param spacing 间隔 默认6.0
 */
- (void)wb_horizontalCenterTitleAndImageRight:(CGFloat)spacing;
- (void)wb_horizontalCenterTitleAndImageRight;

@end
