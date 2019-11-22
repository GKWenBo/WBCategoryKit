//
//  CALayer+WBAdditional.m
//  Pods
//
//  Created by 文波 on 2019/11/19.
//

#import "CALayer+WBAdditional.h"
#import "WBCategoryKitCore.h"

@implementation CALayer (WBAdditional)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 由于其他方法需要通过调用 wblayer_setCornerRadius: 来执行 swizzle 前的实现，所以这里暂时用 ExchangeImplementations
        WBExchangeImplementations([CALayer class], @selector(setCornerRadius:), @selector(wb_setCornerRadius:));
        
        WBExtendImplementationOfNonVoidMethodWithoutArguments([CALayer class], @selector(init), CALayer *, ^CALayer *(CALayer *selfObject, CALayer *originReturnValue) {
            selfObject.wb_maskedCorners = WBUILayerMinXMinYCorner|WBUILayerMaxXMinYCorner|WBUILayerMinXMaxYCorner|WBUILayerMaxXMaxYCorner;
            return originReturnValue;
        })
        
    });
}

- (BOOL)wb_isRootLayerOfView {
    return [self.delegate isKindOfClass:[UIView class]] && ((UIView *)self.delegate).layer == self;
}

- (void)wb_removeDefaultAnimations {
    NSMutableDictionary<NSString *, id<CAAction>> *actions = @{NSStringFromSelector(@selector(bounds)): [NSNull null],
                                                               NSStringFromSelector(@selector(position)): [NSNull null],
                                                               NSStringFromSelector(@selector(zPosition)): [NSNull null],
                                                               NSStringFromSelector(@selector(anchorPoint)): [NSNull null],
                                                               NSStringFromSelector(@selector(anchorPointZ)): [NSNull null],
                                                               NSStringFromSelector(@selector(transform)): [NSNull null],
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                                               NSStringFromSelector(@selector(hidden)): [NSNull null],
                                                               NSStringFromSelector(@selector(doubleSided)): [NSNull null],
#pragma clang diagnostic pop
                                                               NSStringFromSelector(@selector(sublayerTransform)): [NSNull null],
                                                               NSStringFromSelector(@selector(masksToBounds)): [NSNull null],
                                                               NSStringFromSelector(@selector(contents)): [NSNull null],
                                                               NSStringFromSelector(@selector(contentsRect)): [NSNull null],
                                                               NSStringFromSelector(@selector(contentsScale)): [NSNull null],
                                                               NSStringFromSelector(@selector(contentsCenter)): [NSNull null],
                                                               NSStringFromSelector(@selector(minificationFilterBias)): [NSNull null],
                                                               NSStringFromSelector(@selector(backgroundColor)): [NSNull null],
                                                               NSStringFromSelector(@selector(cornerRadius)): [NSNull null],
                                                               NSStringFromSelector(@selector(borderWidth)): [NSNull null],
                                                               NSStringFromSelector(@selector(borderColor)): [NSNull null],
                                                               NSStringFromSelector(@selector(opacity)): [NSNull null],
                                                               NSStringFromSelector(@selector(compositingFilter)): [NSNull null],
                                                               NSStringFromSelector(@selector(filters)): [NSNull null],
                                                               NSStringFromSelector(@selector(backgroundFilters)): [NSNull null],
                                                               NSStringFromSelector(@selector(shouldRasterize)): [NSNull null],
                                                               NSStringFromSelector(@selector(rasterizationScale)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowColor)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowOpacity)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowOffset)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowRadius)): [NSNull null],
                                                               NSStringFromSelector(@selector(shadowPath)): [NSNull null]}.mutableCopy;
    
    if ([self isKindOfClass:[CAShapeLayer class]]) {
        [actions addEntriesFromDictionary:@{NSStringFromSelector(@selector(path)): [NSNull null],
                                            NSStringFromSelector(@selector(fillColor)): [NSNull null],
                                            NSStringFromSelector(@selector(strokeColor)): [NSNull null],
                                            NSStringFromSelector(@selector(strokeStart)): [NSNull null],
                                            NSStringFromSelector(@selector(strokeEnd)): [NSNull null],
                                            NSStringFromSelector(@selector(lineWidth)): [NSNull null],
                                            NSStringFromSelector(@selector(miterLimit)): [NSNull null],
                                            NSStringFromSelector(@selector(lineDashPhase)): [NSNull null]}];
    }
    
    if ([self isKindOfClass:[CAGradientLayer class]]) {
        [actions addEntriesFromDictionary:@{NSStringFromSelector(@selector(colors)): [NSNull null],
                                            NSStringFromSelector(@selector(locations)): [NSNull null],
                                            NSStringFromSelector(@selector(startPoint)): [NSNull null],
                                            NSStringFromSelector(@selector(endPoint)): [NSNull null]}];
    }
    
    self.actions = actions;
}

- (void)wb_setCornerRadius:(CGFloat)cornerRadius {
    BOOL cornerRadiusChanged = wb_flat(self.wb_originCornerRadius) != wb_flat(cornerRadius);// flat 处理，避免浮点精度问题
    self.wb_originCornerRadius = cornerRadius;
    if (@available(iOS 11.0, *)) {
        [self wb_setCornerRadius:cornerRadius];
    } else {
        if (self.wb_maskedCorners && ![self wb_hasFourCornerRadius]) {
            [self wb_setCornerRadius:0];
        }else {
            [self wb_setCornerRadius:cornerRadius];
        }
        
        // 需要刷新mask
        if (cornerRadiusChanged) {
            [self setNeedsLayout];
        }
    }
    
    if (cornerRadiusChanged) {
        if ([self.delegate respondsToSelector:@selector(layoutSublayersOfLayer:)]) {
            UIView *view = (UIView *)self.delegate;
            if (view.wb_borderPosition > 0 && view.wb_borderWidth > 0) {
                [view layoutSublayersOfLayer:self];
            }
        }
    }
}

- (BOOL)wb_hasFourCornerRadius {
    return (self.wb_maskedCorners & WBUILayerMinXMinYCorner) == WBUILayerMinXMinYCorner &&
           (self.wb_maskedCorners & WBUILayerMaxXMinYCorner) == WBUILayerMaxXMinYCorner &&
           (self.wb_maskedCorners & WBUILayerMinXMaxYCorner) == WBUILayerMinXMaxYCorner &&
           (self.wb_maskedCorners & WBUILayerMaxXMaxYCorner) == WBUILayerMaxXMaxYCorner;
}

+ (void)wb_performWithoutAnimation:(void (NS_NOESCAPE ^)(void))actionsWithoutAnimation {
    if (!actionsWithoutAnimation) return;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    actionsWithoutAnimation();
    [CATransaction commit];
}

// MARK:setter
static char kWBAssociatedObjectKey_maskedCorners;
- (void)setWb_maskedCorners:(WBUICornerMask)wb_maskedCorners {
    BOOL maskedCornersChanged = wb_maskedCorners != self.wb_maskedCorners;
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_maskedCorners, @(wb_maskedCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (@available(iOS 11.0, *)) {
        self.maskedCorners = (CACornerMask)wb_maskedCorners;
    } else {
        if (wb_maskedCorners && ![self wb_hasFourCornerRadius]) {
            [self wb_setCornerRadius:0];
        }
        
        if (maskedCornersChanged) {
            if ([NSThread isMainThread]) {
                [self setNeedsLayout];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setNeedsLayout];
                });
            }
        }
    }
    
    if (maskedCornersChanged) {
        // 需要刷新border
        if ([self.delegate respondsToSelector:@selector(layoutSublayersOfLayer:)]) {
            UIView *view = (UIView *)self.delegate;
            if (view.wb_borderPosition > 0 && view.wb_borderWidth > 0) {
                [view layoutSublayersOfLayer:self];
            }
        }
    }
}

- (WBUICornerMask)wb_maskedCorners {
    return [(NSNumber *)objc_getAssociatedObject(self, &kWBAssociatedObjectKey_maskedCorners) unsignedIntegerValue];
}

static char kWBAssociatedObjectKey_originCornerRadius;
- (void)setWb_originCornerRadius:(CGFloat)wb_originCornerRadius {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_originCornerRadius, @(wb_originCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)wb_originCornerRadius {
    return [objc_getAssociatedObject(self, &kWBAssociatedObjectKey_originCornerRadius) floatValue];
}

@end

@implementation UIView (WBUI_CornerRadius)

static NSString *kMaskName = @"WBUI_CornerRadius_Mask";
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        WBExtendImplementationOfVoidMethodWithSingleArgument([UIView class], @selector(layoutSublayersOfLayer:), CALayer *, ^(UIView *selfObject, CALayer *layer) {
            if (@available(iOS 11.0, *)) {
            } else {
                if (selfObject.layer.mask && ![selfObject.layer.name isEqualToString:kMaskName]) {
                    return;
                }
                
                if (selfObject.layer.wb_maskedCorners) {
                    if (selfObject.layer.wb_originCornerRadius <= 0 || [selfObject wb_hasFourCornerRadius]) {
                        if (selfObject.layer.mask) {
                            selfObject.layer.mask = nil;
                        }
                    }else {
                        CAShapeLayer *cornerMaskLayer = [CAShapeLayer layer];
                        cornerMaskLayer.name = kMaskName;
                        UIRectCorner rectCorner = 0;
                        if ((selfObject.layer.wb_maskedCorners & WBUILayerMinXMinYCorner) == WBUILayerMinXMinYCorner) {
                            rectCorner |= UIRectCornerTopLeft;
                        }
                        if ((selfObject.layer.wb_maskedCorners & WBUILayerMaxXMinYCorner) == WBUILayerMaxXMinYCorner) {
                            rectCorner |= UIRectCornerTopRight;
                        }
                        if ((selfObject.layer.wb_maskedCorners & WBUILayerMinXMaxYCorner) == WBUILayerMinXMaxYCorner) {
                            rectCorner |= UIRectCornerBottomLeft;
                        }
                        if ((selfObject.layer.wb_maskedCorners & WBUILayerMaxXMaxYCorner) == WBUILayerMaxXMaxYCorner) {
                            rectCorner |= UIRectCornerBottomRight;
                        }
                        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:selfObject.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(selfObject.layer.wb_originCornerRadius, selfObject.layer.wb_originCornerRadius)];
                        cornerMaskLayer.frame = WBCGRectMakeWithSize(selfObject.bounds.size);
                        cornerMaskLayer.path = path.CGPath;
                        selfObject.layer.mask = cornerMaskLayer;
                    }
                }
                
            }
        });
        
    });
}

- (BOOL)wb_hasFourCornerRadius {
    return (self.layer.wb_maskedCorners & WBUILayerMinXMinYCorner) == WBUILayerMinXMinYCorner &&
           (self.layer.wb_maskedCorners & WBUILayerMaxXMinYCorner) == WBUILayerMaxXMinYCorner &&
           (self.layer.wb_maskedCorners & WBUILayerMinXMaxYCorner) == WBUILayerMinXMaxYCorner &&
           (self.layer.wb_maskedCorners & WBUILayerMaxXMaxYCorner) == WBUILayerMaxXMaxYCorner;
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
