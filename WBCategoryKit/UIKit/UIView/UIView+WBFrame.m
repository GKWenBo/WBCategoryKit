//
//  UIView+WB_Frame.m
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIView+WBFrame.h"

@implementation UIView (WBFrame)
- (CGFloat)wb_left {
    return self.frame.origin.x;
}

- (void)setWb_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)wb_top {
    return self.frame.origin.y;
}

- (void)setWb_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)wb_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setWb_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)wb_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setWb_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)wb_width {
    return self.frame.size.width;
}

- (void)setWb_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)wb_height {
    return self.frame.size.height;
}

- (void)setWb_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)wb_centerX {
    return self.center.x;
}

- (void)setWb_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)wb_centerY {
    return self.center.y;
}

- (void)setWb_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)wb_origin {
    return self.frame.origin;
}

- (void)setWb_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)wb_size {
    return self.frame.size;
}

- (void)setWb_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)wb_maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setWb_maxX:(CGFloat)maxX {
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}

- (CGFloat)wb_maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setWb_maxY:(CGFloat)maxY {
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}
@end
