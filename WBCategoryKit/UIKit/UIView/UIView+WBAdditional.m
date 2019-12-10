//
//  UIView+WB_Additional.m
//  UIViewUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIView+WBAdditional.h"
#import <objc/runtime.h>

#import "WBCategoryKitCore.h"

@implementation UIView (WBAdditional)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        WBExtendImplementationOfVoidMethodWithSingleArgument([UIView class], @selector(setTintColor:), UIColor *, ^(UIView *selfObject, UIColor *tintColor) {
            selfObject.wb_tintColorCustomized = !!tintColor;
        });
        
        ///setFrame:
        WBOverrideImplementation([UIView class], @selector(setFrame:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGRect frame) {
                // QMUIViewSelfSizingHeight 的功能
                if (CGRectGetWidth(frame) > 0 && isinf(CGRectGetHeight(frame))) {
                    CGFloat height = wb_flat([selfObject sizeThatFits:CGSizeMake(CGRectGetWidth(frame), CGFLOAT_MAX)].height);
                    frame = WBCGRectSetHeight(frame, height);
                }
                
                // 对非法的 frame，Debug 下中 assert，Release 下会将其中的 NaN 改为 0，避免 crash
                if (WBCGRectIsNaN(frame)) {
                    if (!WB_IS_DEBUG) {
                        frame = WBCGRectSafeValue(frame);
                    }
                }
                
                CGRect precedingFrame = selfObject.frame;
                BOOL valueChange = !CGRectEqualToRect(frame, precedingFrame);
                if (selfObject.wb_frameWillChangeBlock && valueChange) {
                    frame = selfObject.wb_frameWillChangeBlock(selfObject, frame);
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGRect);
                originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, frame);
                
                if (selfObject.wb_frameDidChangeBlock && valueChange) {
                    selfObject.wb_frameDidChangeBlock(selfObject, precedingFrame);
                }
            };
        });
        
        ///setBounds:
        WBOverrideImplementation([UIView class], @selector(setBounds:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGRect bounds) {
                CGRect precedingFrame = selfObject.frame;
                CGRect precedingBounds = selfObject.bounds;
                BOOL valueChange = !CGSizeEqualToSize(bounds.size, precedingBounds.size);// bounds 只有 size 发生变化才会影响 frame
                if (selfObject.wb_frameWillChangeBlock && valueChange) {
                    CGRect followingFrame = CGRectMake(CGRectGetMinX(precedingFrame) + WBCGFloatGetCenter(CGRectGetWidth(bounds), CGRectGetWidth(precedingFrame)), CGRectGetMinY(precedingFrame) + WBCGFloatGetCenter(CGRectGetHeight(bounds), CGRectGetHeight(precedingFrame)), bounds.size.width, bounds.size.height);
                    followingFrame = selfObject.wb_frameWillChangeBlock(selfObject, followingFrame);
                    bounds = WBCGRectSetSize(bounds, followingFrame.size);
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGRect);
                originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, bounds);
                
                if (selfObject.wb_frameDidChangeBlock && valueChange) {
                    selfObject.wb_frameDidChangeBlock(selfObject, precedingFrame);
                }
            };
        });
        
        WBOverrideImplementation([UIView class], @selector(setCenter:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGPoint center) {
                CGRect precedingFrame = selfObject.frame;
                CGPoint precedingCenter = selfObject.center;
                BOOL valueChange = !CGPointEqualToPoint(center, precedingCenter);
                if (selfObject.wb_frameWillChangeBlock && valueChange) {
                    CGRect followingFrame = WBCGRectSetXY(precedingFrame, center.x - CGRectGetWidth(selfObject.frame) / 2, center.y - CGRectGetHeight(selfObject.frame) / 2);
                    followingFrame = selfObject.wb_frameWillChangeBlock(selfObject, followingFrame);
                    center = CGPointMake(CGRectGetMidX(followingFrame), CGRectGetMidY(followingFrame));
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGPoint);
                originSelectorIMP = (void (*)(id, SEL, CGPoint))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, center);
                
                if (selfObject.wb_frameDidChangeBlock && valueChange) {
                    selfObject.wb_frameDidChangeBlock(selfObject, precedingFrame);
                }
            };
        });
        
        WBOverrideImplementation([UIView class], @selector(setTransform:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGAffineTransform transform) {
                CGRect precedingFrame = selfObject.frame;
                CGAffineTransform precedingTransform = selfObject.transform;
                BOOL valueChange = !CGAffineTransformEqualToTransform(transform, precedingTransform);
                if (selfObject.wb_frameWillChangeBlock && valueChange) {
                    CGRect followingFrame = WBCGRectApplyAffineTransformWithAnchorPoint(precedingFrame, transform, selfObject.layer.anchorPoint);
                    selfObject.wb_frameWillChangeBlock(selfObject, followingFrame);// 对于 CGAffineTransform，无法根据修改后的 rect 来算出新的 transform，所以就不修改 transform 的值了
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGAffineTransform);
                originSelectorIMP = (void (*)(id, SEL, CGAffineTransform))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, transform);
                
                if (selfObject.wb_frameDidChangeBlock && valueChange) {
                    selfObject.wb_frameDidChangeBlock(selfObject, precedingFrame);
                }
            };
        });
        
    });
}

// MARK: - Property
- (UIEdgeInsets)wb_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

- (void)setWb_frameApplyTransform:(CGRect)wb_frameApplyTransform {
    self.frame = WBCGRectApplyAffineTransformWithAnchorPoint(wb_frameApplyTransform, self.transform, self.layer.anchorPoint);
}

- (CGRect)wb_frameApplyTransform {
    return self.frame;
}

- (void)setWb_tintColorCustomized:(BOOL)wb_tintColorCustomized {
    objc_setAssociatedObject(self, @selector(wb_tintColorCustomized), @(wb_tintColorCustomized), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wb_tintColorCustomized {
    return [objc_getAssociatedObject(self, @selector(wb_tintColorCustomized)) boolValue];
}

- (void)setWb_frameWillChangeBlock:(CGRect (^)(__kindof UIView * _Nonnull, CGRect))wb_frameWillChangeBlock {
    objc_setAssociatedObject(self, @selector(wb_frameWillChangeBlock), wb_frameWillChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect (^)(UIView * _Nonnull, CGRect))wb_frameWillChangeBlock {
    return objc_getAssociatedObject(self, @selector(wb_frameWillChangeBlock));
}

- (void)setWb_frameDidChangeBlock:(void (^)(__kindof UIView * _Nonnull, CGRect))wb_frameDidChangeBlock {
    objc_setAssociatedObject(self, @selector(wb_frameDidChangeBlock), wb_frameDidChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIView * _Nonnull, CGRect))wb_frameDidChangeBlock {
    return objc_getAssociatedObject(self, @selector(wb_frameDidChangeBlock));
}

- (void)setWb_tintColorDidChangeBlock:(void (^)(__kindof UIView * _Nonnull))wb_tintColorDidChangeBlock {
    objc_setAssociatedObject(self, @selector(wb_tintColorDidChangeBlock), wb_tintColorDidChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIView * _Nonnull))wb_tintColorDidChangeBlock {
    return objc_getAssociatedObject(self, @selector(wb_tintColorDidChangeBlock));
}

- (void)setWb_hitTestBlock:(__kindof UIView * _Nonnull (^)(CGPoint, UIEvent * _Nonnull, __kindof UIView * _Nonnull))wb_hitTestBlock {
    objc_setAssociatedObject(self, @selector(wb_hitTestBlock), wb_hitTestBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView * _Nonnull (^)(CGPoint, UIEvent * _Nonnull, UIView * _Nonnull))wb_hitTestBlock {
    return objc_getAssociatedObject(self, @selector(wb_hitTestBlock));
}

static char kAssociatedObjectKey_layoutSubviewsBlock;
static NSMutableSet *wb_registeredLayoutSubviewsBlockClasses;
- (void)setWb_layoutSubviewsBlock:(void (^)(__kindof UIView * _Nonnull))wb_layoutSubviewsBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_layoutSubviewsBlock, wb_layoutSubviewsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (!wb_registeredLayoutSubviewsBlockClasses) wb_registeredLayoutSubviewsBlockClasses = [NSMutableSet set];
    if (wb_layoutSubviewsBlock) {
        Class viewClass = self.class;
        if (![wb_registeredLayoutSubviewsBlockClasses containsObject:viewClass]) {
            // Extend 每个实例对象的类是为了保证比子类的 layoutSubviews 逻辑要更晚调用
            WBExtendImplementationOfVoidMethodWithoutArguments(viewClass, @selector(layoutSubviews), ^(__kindof UIView *selfObject) {
                if (selfObject.wb_layoutSubviewsBlock && [selfObject isMemberOfClass:viewClass]) {
                    selfObject.wb_layoutSubviewsBlock(selfObject);
                }
            });
            [wb_registeredLayoutSubviewsBlockClasses addObject:viewClass];
        }
    }
}

- (void (^)(UIView * _Nonnull))wb_layoutSubviewsBlock {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_layoutSubviewsBlock);
}

// MARK: - Initializer
- (instancetype)wb_initWithSize:(CGSize)size {
    return [self initWithFrame:CGRectMake(0, 0, size.width, size.height)];
}

#pragma mark - Event
- (void)wb_addTapGestureTarget:(id)target
                        action:(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target
                                                                         action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

#pragma mark - Border
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

#pragma mark - 子视图
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

#pragma mark - 添加视图到Window上
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

#pragma mark - 位置
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

#pragma mark - 绘制虚线
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

// MARK: - Methods
+ (void)wb_animateWithAnimated:(BOOL)animated
                      duration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                       options:(UIViewAnimationOptions)options
                    animations:(void (^)(void))animations
                    completion:(void (^ __nullable)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:duration
                              delay:delay
                            options:options
                         animations:animations
                         completion:completion];
    } else {
        if (animations) {
            animations();
        }
        if (completion) {
            completion(YES);
        }
    }
}
+ (void)wb_animateWithAnimated:(BOOL)animated
                      duration:(NSTimeInterval)duration
                    animations:(void (^ __nullable)(void))animations
                    completion:(void (^ __nullable)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:duration
                         animations:animations
                         completion:completion];
    } else {
        if (animations) {
            animations();
        }
        if (completion) {
            completion(YES);
        }
    }
}
+ (void)wb_animateWithAnimated:(BOOL)animated
                      duration:(NSTimeInterval)duration
                    animations:(void (^ __nullable)(void))animations {
    if (animated) {
        [UIView animateWithDuration:duration
                         animations:animations];
    } else {
        if (animations) {
            animations();
        }
    }
}
+ (void)wb_animateWithAnimated:(BOOL)animated
                      duration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
        usingSpringWithDamping:(CGFloat)dampingRatio
         initialSpringVelocity:(CGFloat)velocity
                       options:(UIViewAnimationOptions)options
                    animations:(void (^)(void))animations
                    completion:(void (^)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:duration
                              delay:delay
             usingSpringWithDamping:dampingRatio
              initialSpringVelocity:velocity
                            options:options
                         animations:animations
                         completion:completion];
    } else {
        if (animations) {
            animations();
        }
        if (completion) {
            completion(YES);
        }
    }
}

@end

@implementation UIView (WBSnapshot)

#pragma mark - 截屏
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

- (CGFloat)wb_extendToTop {
    return self.wb_top;
}

- (void)setWb_extendToTop:(CGFloat)wb_extendToTop {
    self.wb_height = self.wb_bottom - wb_extendToTop;
    self.wb_top = wb_extendToTop;
}

- (CGFloat)wb_extendToLeft {
    return self.wb_left;
}

- (void)setWb_extendToLeft:(CGFloat)wb_extendToLeft {
    self.wb_width = self.wb_right - wb_extendToLeft;
    self.wb_left = wb_extendToLeft;
}

- (CGFloat)wb_extendToBottom {
    return self.wb_bottom;
}

- (void)setWb_extendToBottom:(CGFloat)wb_extendToBottom {
    self.wb_height = wb_extendToBottom - self.wb_top;
    self.wb_bottom = wb_extendToBottom;
}

- (CGFloat)wb_extendToRight {
    return self.wb_right;
}

- (void)setWb_extendToRight:(CGFloat)wb_extendToRight {
    self.wb_width = wb_extendToRight - self.wb_left;
    self.wb_right = wb_extendToRight;
}

- (CGFloat)wb_leftWhenCenterInSuperview {
    return WBCGFloatGetCenter(CGRectGetWidth(self.superview.bounds), CGRectGetWidth(self.frame));
}

- (CGFloat)wb_topWhenCenterInSuperview {
    return WBCGFloatGetCenter(CGRectGetHeight(self.superview.bounds), CGRectGetHeight(self.frame));
}

@end


@implementation UIView (WBCGAffineTransform)

- (CGFloat)wb_scaleX {
    return self.transform.a;
}

- (CGFloat)wb_scaleY {
    return self.transform.d;
}

- (CGFloat)wb_translationX {
    return self.transform.tx;
}

- (CGFloat)wb_translationY {
    return self.transform.ty;
}

@end
