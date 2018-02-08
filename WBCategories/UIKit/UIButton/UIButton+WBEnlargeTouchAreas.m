//
//  UIButton+WB_EnlargeTouchAreas.m
//  WB_UIButtonManager
//
//  Created by WMB on 2017/6/1.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIButton+WBEnlargeTouchAreas.h"
#import <objc/runtime.h>

@implementation UIButton (WBEnlargeTouchAreas)

- (UIEdgeInsets)touchAreaInsets
{
    return [objc_getAssociatedObject(self, @selector(touchAreaInsets)) UIEdgeInsetsValue];
}
/**
 *  @brief  设置按钮额外热区
 */
- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets
{
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}


@end
