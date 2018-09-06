//
//  UIView+WB_Extension.m
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/15.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIView+WBExtension.h"

@implementation UIView (WBExtension)

#pragma mark -- Event
- (void)wb_addTapGestureTarget:(id)target
                        action:(SEL)action {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:target
                                                                          action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

#pragma mark -- Border
- (void)wb_addBorderWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth
                 cornerRadius:(CGFloat)cornerRadius {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = cornerRadius;
}

- (void)wb_addBorderAndCornerRadiusWithColor:(UIColor *)color {
    [self wb_addBorderWithColor:color
                    borderWidth:0.5f
                   cornerRadius:4.f];
}

- (void)wb_addBorderWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth {
    [self wb_addBorderWithColor:color
                    borderWidth:borderWidth
                   cornerRadius:0.f];
}

#pragma mark -- CornerRadius
- (void)wb_setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)wb_setCircleCornerRadius {
    NSAssert(self.bounds.size.width != self.bounds.size.height, @"请检查视图frame设置是否正确");
    [self wb_setCornerRadius:self.bounds.size.width];
}

- (void)wb_setBezierCornerRadiusByRoundingCorners:(WBRectCornerType)rectCorner
                                     cornerRadius:(CGFloat)cornerRadius {
    UIRectCorner corner;
    switch (rectCorner) {
        case WBRectCornerTop:
            corner = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case WBRectCornerLeft:
            corner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            break;
        case WBRectCornerBottom:
            corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case WBRectCornerRight:
            corner = UIRectCornerBottomRight | UIRectCornerTopRight;
            break;
        case WBRectCornerAll:
            corner = UIRectCornerAllCorners;
            break;
        default:
            break;
    }
    
    CGSize size = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    byRoundingCorners:corner cornerRadii:size];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark --------  子视图  --------
- (NSArray *)superviews {
    NSMutableArray *superviews = [[NSMutableArray alloc] init];
    
    UIView *view = self;
    UIView *superview = nil;
    while (view) {
        superview = [view superview];
        if (!superview) {
            break;
        }
        
        [superviews addObject:superview];
        view = superview;
    }
    return superviews;
}

#pragma mark --------  添加视图到Window上  --------
- (void)wb_addToWindow {
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(window)])
    {
        UIWindow * window = (UIWindow *) [appDelegate performSelector:@selector(window)];
        [window addSubview:self];
    }
}

@end
