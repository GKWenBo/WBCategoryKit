//
//  UIView+WB_BlurEffect.m
//  UIViewUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIView+WBBlurEffect.h"

@implementation UIView (WBBlurEffect)

+ (UIVisualEffectView *)wb_effectViewWithFrame:(CGRect)frame {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    return effectView;
}

@end
