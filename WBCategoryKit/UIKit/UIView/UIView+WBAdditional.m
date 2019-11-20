//
//  UIView+WB_Additional.m
//  UIViewUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIView+WBAdditional.h"
#import <objc/runtime.h>
#import "NSObject+WBRuntime.h"
#import "CALayer+WBAdditional.h"
#import "WBHelper.h"

@implementation UIView (WBAdditional)

// MARK:Property
- (UIEdgeInsets)wb_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

- (instancetype)wb_initWithSize:(CGSize)size {
    return [self initWithFrame:CGRectMake(0, 0, size.width, size.height)];
}

#pragma mark -- Event
- (void)wb_addTapGestureTarget:(id)target
                        action:(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target
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
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
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

- (void)wb_setLayerShadow:(UIColor *)color
                   offset:(CGSize)offset
                   radius:(CGFloat)radius {
    self.layer.shadowColor  = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;

}

- (void)wb_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

#pragma mark --------  位置  --------
- (CGPoint)wb_convertPoint:(CGPoint)point
            toViewOrWindow:(nullable UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)wb_convertPoint:(CGPoint)point
          fromViewOrWindow:(nullable UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)wb_convertRect:(CGRect)rect
          toViewOrWindow:(nullable UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

- (CGRect)wb_convertRect:(CGRect)rect
        fromViewOrWindow:(nullable UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}

#pragma mark --------  绘制虚线  --------
+ (UIView *)wb_createDashedLineWithFrame:(CGRect)lineFrame
                              lineLength:(int)length
                             lineSpacing:(int)spacing
                               lineColor:(UIColor *)color {
    UIView *dashedLine = [[UIView alloc] initWithFrame:lineFrame];
    dashedLine.backgroundColor = [UIColor clearColor];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:dashedLine.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(dashedLine.frame) / 2, CGRectGetHeight(dashedLine.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(dashedLine.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:length], [NSNumber numberWithInt:spacing], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(dashedLine.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [dashedLine.layer addSublayer:shapeLayer];
    return dashedLine;
}

@end

@implementation UIView (WBSnapshot)

#pragma mark --------  截屏  --------
- (UIImage *)wb_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)wb_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self wb_snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;

}

- (NSData *)wb_snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (UIImage*)wb_screenshotInFrame:(CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), frame.origin.x, frame.origin.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

- (UIImage*)wb_screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset {
    UIGraphicsBeginImageContext(self.bounds.size);
    //need to translate the context down to the current visible portion of the scrollview
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, -contentOffset.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.55);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

+ (UIImage *)wb_captureScrollView:(UIScrollView *)scrollView {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }
    return nil;
}

@end

@interface UIView ()

@property (nonatomic, strong) CAShapeLayer *wb_borderLayer;

@end

@implementation UIView (WBBorder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        WBExtendImplementationOfNonVoidMethodWithSingleArgument([UIView class], @selector(initWithFrame:), CGRect, UIView *, ^UIView *(UIView *selfObject, CGRect frame, UIView *originReturnValue) {
            [selfObject wb_setDefaultStyle];
            return originReturnValue;
        });
        
        WBExtendImplementationOfNonVoidMethodWithSingleArgument([UIView class], @selector(initWithCoder:), NSCoder *, UIView *, ^UIView *(UIView *selfObject, NSCoder *aDecoder, UIView *originReturnValue) {
            [selfObject wb_setDefaultStyle];
            return originReturnValue;
        });
        
        WBExtendImplementationOfVoidMethodWithSingleArgument([UIView class], @selector(layoutSublayersOfLayer:), CALayer *, ^(UIView *selfObject, CALayer *layer) {
            if ((!selfObject.wb_borderLayer && selfObject.wb_borderPosition == WBUIViewBorderPositionNone) || (!selfObject.wb_borderLayer && selfObject.wb_borderWidth == 0)) {
                return;
            }
            
            if (selfObject.wb_borderLayer && selfObject.wb_borderPosition == WBUIViewBorderPositionNone && !selfObject.wb_borderLayer.path) {
                return;
            }
            
            if (selfObject.wb_borderLayer && selfObject.wb_borderWidth == 0 && selfObject.wb_borderLayer.lineWidth == 0) {
                return;
            }
            
            if (!selfObject.wb_borderLayer) {
                selfObject.wb_borderLayer = [CAShapeLayer layer];
                selfObject.wb_borderLayer.fillColor = [UIColor clearColor].CGColor;
                [selfObject.wb_borderLayer wb_removeDefaultAnimations];
                [selfObject.layer addSublayer:selfObject.wb_borderLayer];
            }
            selfObject.wb_borderLayer.frame = selfObject.bounds;
            
            CGFloat borderWidth = selfObject.wb_borderWidth;
            selfObject.wb_borderLayer.lineWidth = borderWidth;
            selfObject.wb_borderLayer.strokeColor = selfObject.wb_borderColor.CGColor;
            selfObject.wb_borderLayer.lineDashPhase = selfObject.wb_dashPhase;
            selfObject.wb_borderLayer.lineDashPattern = selfObject.wb_dashPattern;
            
            UIBezierPath *path = nil;
            
            if (selfObject.wb_borderPosition != WBUIViewBorderPositionNone) {
                path = [UIBezierPath bezierPath];
            }
            
            CGFloat (^adjustsLocation)(CGFloat, CGFloat, CGFloat) = ^CGFloat(CGFloat inside, CGFloat center, CGFloat outside) {
                return selfObject.wb_borderLocation == WBUIViewBorderLocationInside ? inside : (selfObject.wb_borderLocation == WBUIViewBorderLocationCenter ? center : outside);
            };
            
            CGFloat lineOffset = adjustsLocation(borderWidth / 2.0, 0, -borderWidth / 2.0); // 为了像素对齐而做的偏移
            CGFloat lineCapOffset = adjustsLocation(0, borderWidth / 2.0, borderWidth); // 两条相邻的边框连接的位置
            
            BOOL shouldShowTopBorder = (selfObject.wb_borderPosition & WBUIViewBorderPositionTop) == WBUIViewBorderPositionTop;
            BOOL shouldShowLeftBorder = (selfObject.wb_borderPosition & WBUIViewBorderPositionLeft) == WBUIViewBorderPositionLeft;
            BOOL shouldShowBottomBorder = (selfObject.wb_borderPosition & WBUIViewBorderPositionBottom) == WBUIViewBorderPositionBottom;
            BOOL shouldShowRightBorder = (selfObject.wb_borderPosition & WBUIViewBorderPositionRight) == WBUIViewBorderPositionRight;
            
            UIBezierPath *topPath = [UIBezierPath bezierPath];
            UIBezierPath *leftPath = [UIBezierPath bezierPath];
            UIBezierPath *bottomPath = [UIBezierPath bezierPath];
            UIBezierPath *rightPath = [UIBezierPath bezierPath];
            
            if (selfObject.layer.wb_originCornerRadius > 0) {
                
                CGFloat cornerRadius = selfObject.layer.wb_originCornerRadius;
                
                if (selfObject.layer.wb_maskedCorners) {
                    if ((selfObject.layer.wb_maskedCorners & WBUILayerMinXMinYCorner) == WBUILayerMinXMinYCorner) {
                        [topPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.25 * M_PI endAngle:1.5 * M_PI clockwise:YES];
                        [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, lineOffset)];
                        [leftPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:-0.75 * M_PI endAngle:-1 * M_PI clockwise:NO];
                        [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) - cornerRadius)];
                    } else {
                        [topPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, lineOffset)];
                        [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, lineOffset)];
                        [leftPath moveToPoint:CGPointMake(lineOffset, shouldShowTopBorder ? -lineCapOffset : 0)];
                        [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) - cornerRadius)];
                    }
                    if ((selfObject.layer.wb_maskedCorners & WBUILayerMinXMaxYCorner) == WBUILayerMinXMaxYCorner) {
                        [leftPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1 * M_PI endAngle:-1.25 * M_PI clockwise:NO];
                        [bottomPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.25 * M_PI endAngle:-1.5 * M_PI clockwise:NO];
                        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - lineOffset)];
                    } else {
                        [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                        CGFloat y = CGRectGetHeight(selfObject.bounds) - lineOffset;
                        [bottomPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, y)];
                        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, y)];
                    }
                    if ((selfObject.layer.wb_maskedCorners & WBUILayerMaxXMaxYCorner) == WBUILayerMaxXMaxYCorner) {
                        [bottomPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.5 * M_PI endAngle:-1.75 * M_PI clockwise:NO];
                        [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.75 * M_PI endAngle:-2 * M_PI clockwise:NO];
                        [rightPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - lineOffset, cornerRadius)];
                    } else {
                        CGFloat y = CGRectGetHeight(selfObject.bounds) - lineOffset;
                        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), y)];
                        CGFloat x = CGRectGetWidth(selfObject.bounds) - lineOffset;
                        [rightPath moveToPoint:CGPointMake(x, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                        [rightPath addLineToPoint:CGPointMake(x, cornerRadius)];
                    }
                    if ((selfObject.layer.wb_maskedCorners & WBUILayerMaxXMinYCorner) == WBUILayerMaxXMinYCorner) {
                        [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:0 * M_PI endAngle:-0.25 * M_PI clockwise:NO];
                        [topPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.5 * M_PI endAngle:1.75 * M_PI clockwise:YES];
                    } else {
                        CGFloat x = CGRectGetWidth(selfObject.bounds) - lineOffset;
                        [rightPath addLineToPoint:CGPointMake(x, shouldShowTopBorder ? -lineCapOffset : 0)];
                        [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), lineOffset)];
                    }
                } else {
                    [topPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.25 * M_PI endAngle:1.5 * M_PI clockwise:YES];
                    [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, lineOffset)];
                    [topPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.5 * M_PI endAngle:1.75 * M_PI clockwise:YES];
                    
                    [leftPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:-0.75 * M_PI endAngle:-1 * M_PI clockwise:NO];
                    [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) - cornerRadius)];
                    [leftPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1 * M_PI endAngle:-1.25 * M_PI clockwise:NO];
                    
                    [bottomPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.25 * M_PI endAngle:-1.5 * M_PI clockwise:NO];
                    [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - lineOffset)];
                    [bottomPath addArcWithCenter:CGPointMake(CGRectGetHeight(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.5 * M_PI endAngle:-1.75 * M_PI clockwise:NO];
                    
                    [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.75 * M_PI endAngle:-2 * M_PI clockwise:NO];
                    [rightPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - lineOffset, cornerRadius)];
                    [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:0 * M_PI endAngle:-0.25 * M_PI clockwise:NO];
                }
                
            } else {
                [topPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, lineOffset)];
                [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), lineOffset)];
                
                [leftPath moveToPoint:CGPointMake(lineOffset, shouldShowTopBorder ? -lineCapOffset : 0)];
                [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                
                CGFloat y = CGRectGetHeight(selfObject.bounds) - lineOffset;
                [bottomPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, y)];
                [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), y)];
                
                CGFloat x = CGRectGetWidth(selfObject.bounds) - lineOffset;
                [rightPath moveToPoint:CGPointMake(x, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                [rightPath addLineToPoint:CGPointMake(x, shouldShowTopBorder ? -lineCapOffset : 0)];
            }
            
            if (shouldShowTopBorder && ![topPath isEmpty]) {
                [path appendPath:topPath];
            }
            if (shouldShowLeftBorder && ![leftPath isEmpty]) {
                [path appendPath:leftPath];
            }
            if (shouldShowBottomBorder && ![bottomPath isEmpty]) {
                [path appendPath:bottomPath];
            }
            if (shouldShowRightBorder && ![rightPath isEmpty]) {
                [path appendPath:rightPath];
            }
            
            selfObject.wb_borderLayer.path = path.CGPath;
        });

        
        
    });
}

- (void)wb_setDefaultStyle {
    self.wb_borderWidth = [WBHelper wb_pixelOne];
    if (@available(iOS 13.0, *)) {
        self.wb_borderColor = [UIColor separatorColor];
    } else {
        // Fallback on earlier versions
        self.wb_borderColor = [UIColor lightGrayColor];
    }
}

// MARK: setter && getter
- (void)setWb_borderLayer:(CAShapeLayer *)wb_borderLayer {
    objc_setAssociatedObject(self, @selector(wb_borderLayer), wb_borderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)wb_borderLayer {
    return objc_getAssociatedObject(self, @selector(wb_borderLayer));
}

static char kWBAssociatedObjectKey_borderLocation;
- (void)setWb_borderLocation:(WBUIViewBorderLocation)wb_borderLocation {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_borderLocation, @(wb_borderLocation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (WBUIViewBorderLocation)wb_borderLocation {
    return [(NSNumber *)objc_getAssociatedObject(self, &kWBAssociatedObjectKey_borderLocation) unsignedIntegerValue];
}

static char kWBAssociatedObjectKey_borderPosition;
- (void)setWb_borderPosition:(WBUIViewBorderPosition)wb_borderPosition {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_borderPosition, @(wb_borderPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (WBUIViewBorderPosition)wb_borderPosition {
    return [(NSNumber *)objc_getAssociatedObject(self, &kWBAssociatedObjectKey_borderPosition) floatValue];
}

static char kWBAssociatedObjectKey_borderWidth;
- (void)setWb_borderWidth:(CGFloat)wb_borderWidth {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_borderWidth, @(wb_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)wb_borderWidth {
    return [(NSNumber *)objc_getAssociatedObject(self, &kWBAssociatedObjectKey_borderWidth) floatValue];
}

static char kWBAssociatedObjectKey_borderColor;
- (void)setWb_borderColor:(UIColor *)wb_borderColor {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_borderColor, wb_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (UIColor *)wb_borderColor {
    return (UIColor *)objc_getAssociatedObject(self, &kWBAssociatedObjectKey_borderColor);
}

static char kWBAssociatedObjectKey_dashPhase;
- (void)setWb_dashPhase:(CGFloat)wb_dashPhase {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_dashPhase, @(wb_dashPhase), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)wb_dashPhase {
    return [(NSNumber *)objc_getAssociatedObject(self, &kWBAssociatedObjectKey_dashPhase) floatValue];
}

static char kWBAssociatedObjectKey_dashPattern;
- (void)setWb_dashPattern:(NSArray<NSNumber *> *)wb_dashPattern {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_dashPattern, wb_dashPattern, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (NSArray<NSNumber *> *)wb_dashPattern {
    return (NSArray<NSNumber *> *)objc_getAssociatedObject(self, &kWBAssociatedObjectKey_dashPattern);
}

@end
