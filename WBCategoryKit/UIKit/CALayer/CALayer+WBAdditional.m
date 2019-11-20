//
//  CALayer+WBAdditional.m
//  Pods
//
//  Created by 文波 on 2019/11/19.
//

#import "CALayer+WBAdditional.h"
#import "WBMacro.h"
#import "NSObject+WBRuntime.h"
#import "UIView+WBAdditional.h"

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
