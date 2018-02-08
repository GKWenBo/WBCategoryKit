//
//  UIView+WB_BlurEffect.h
//  UIViewUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WBBlurEffect)

/**
 *  创建实时模糊视图
 *
 *  @param frame 范围
 */
+ (UIVisualEffectView *)wb_effectViewWithFrame:(CGRect)frame;


@end
