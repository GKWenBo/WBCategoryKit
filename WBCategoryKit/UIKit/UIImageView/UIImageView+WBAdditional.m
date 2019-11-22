//
//  UIImageView+WBAdditional.m
//  Pods
//
//  Created by WenBo on 2019/11/20.
//

#import "UIImageView+WBAdditional.h"
#import <objc/runtime.h>

#import "WBCategoryKitCore.h"

@interface UIImageView ()

/// `0`不需更新，`1`需更新normal图片，`2`需更新highlighted图片
@property (nonatomic, assign) NSUInteger imageNeedsResizeTag;

@end

@implementation UIImageView (WBAdditional)

// MARK:getter && setter
- (void)setImageNeedsResizeTag:(NSUInteger)imageNeedsResizeTag {
    objc_setAssociatedObject(self, @selector(imageNeedsResizeTag), @(imageNeedsResizeTag),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)imageNeedsResizeTag {
    return [objc_getAssociatedObject(self, @selector(imageNeedsResizeTag)) unsignedIntegerValue];
}

- (void)setWb_contentMode:(WBUIViewContentMode)wb_contentMode {
    objc_setAssociatedObject(self, @selector(wb_contentMode), @(wb_contentMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (wb_contentMode <= WBUIViewContentModeBottomRight) {
        self.contentMode = (UIViewContentMode)wb_contentMode;
        return;
    }
    
    self.layer.masksToBounds = YES;
    self.imageNeedsResizeTag = self.isHighlighted ? 2 : 1;
    [self wb_updateImageIfNeeded];
}

- (WBUIViewContentMode)wb_contentMode {
    return [objc_getAssociatedObject(self, @selector(wb_contentMode)) integerValue];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WBExchangeImplementations([UIImageView class], @selector(layoutSubviews), @selector(wb_layoutSubviews));
        
        WBExchangeImplementations([UIImageView class], @selector(setImage:), @selector(wb_setImage:));
        
        WBExchangeImplementations([UIImageView class], @selector(setHighlightedImage:), @selector(wb_setHighlightedImage:));
        
        WBExchangeImplementations([UIImageView class], @selector(setHighlighted:), @selector(wb_setHighlighted:));
    });
}

// MARK:swizzle
- (void)wb_layoutSubviews {
    [self wb_layoutSubviews];
    
    if (![self wb_checkMode]) return;
    
    [self wb_updateImageIfNeeded];
}

- (void)wb_setImage:(UIImage *)image {
    [self wb_setImage:image];
    
    if (![self wb_checkMode]) {
        return;
    }
    
    self.imageNeedsResizeTag = 1;
    
    [self wb_updateImageIfNeeded];
}

- (void)wb_setHighlightedImage:(UIImage *)highlightedImage {
    [self wb_setHighlightedImage:highlightedImage];
    
    if (![self wb_checkMode]) {
        return;
    }
    
    self.imageNeedsResizeTag = 2;
    
    [self wb_updateImageIfNeeded];
}

- (void)wb_setHighlighted:(BOOL)highlighted {
    if (self.isHighlighted == highlighted) {
        return;
    }
    
    [self wb_setHighlighted:highlighted];
    
    self.imageNeedsResizeTag = highlighted ? 2 : 1;
    
    [self wb_updateImageIfNeeded];
}

// MARK:Private Method
- (BOOL)wb_checkMode {
    return self.wb_contentMode > WBUIViewContentModeBottomRight;
}

- (void)wb_updateImageIfNeeded {
    if (self.isHidden || self.alpha == 0) {
        return;
    }
    
    if (!self.isHighlighted && self.imageNeedsResizeTag == 1) {
        
        [self wb_fitOriginalImage:self.image];
        self.imageNeedsResizeTag = 0;
    }
    
    if (self.isHighlighted && self.imageNeedsResizeTag == 2) {
        
        [self wb_fitOriginalImage:self.highlightedImage];
        self.imageNeedsResizeTag = 0;
    }
}

- (void)wb_fitOriginalImage:(UIImage *)originalImage {
    if (!originalImage) {
        return;
    }
    
    [self layoutIfNeeded];

    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat imageWidth = originalImage.size.width;
    CGFloat imageHeight = originalImage.size.height;
    CGFloat selfFactor = selfWidth / selfHeight;
    CGFloat imageFactor = imageWidth / imageHeight;

    CGFloat fitlyWidth = selfWidth;
    CGFloat fitlyHeight = selfHeight;
    
    if (selfFactor < imageFactor) {
        
        fitlyHeight = selfHeight;
        fitlyWidth = selfHeight / imageHeight * imageWidth;
        
    } else if (selfFactor > imageFactor) {
        
        fitlyWidth = selfWidth;
        fitlyHeight = selfWidth / imageWidth * imageHeight;
    }
    
    CGFloat widthOffset = fitlyWidth - selfWidth;
    CGFloat heightOffset = fitlyHeight - selfHeight;
    
    CGFloat x = widthOffset / fitlyWidth;
    CGFloat y = heightOffset / fitlyHeight;
    CGFloat width = selfWidth / fitlyWidth;
    CGFloat height = selfHeight / fitlyHeight;
    
    CGRect fitRect = CGRectMake(0, 0, 1, 1);
    switch (self.wb_contentMode) {
            
        case WBUIViewContentModeScaleAspectFitTop:
            fitRect = CGRectMake(x * 0.5, 0, width, height);
            break;
            
        case WBUIViewContentModeScaleAspectFitBottom:
            fitRect = CGRectMake(x * 0.5, y, width, height);
            break;
            
        case WBUIViewContentModeScaleAspectFitLeft:
            fitRect = CGRectMake(0, y * 0.5, width, height);
            break;
            
        case WBUIViewContentModeScaleAspectFitRight:
            fitRect = CGRectMake(x, y * 0.5, width, height);
            break;
            
        default:
            break;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.layer.contentsRect = fitRect;
    [CATransaction commit];
}

@end
