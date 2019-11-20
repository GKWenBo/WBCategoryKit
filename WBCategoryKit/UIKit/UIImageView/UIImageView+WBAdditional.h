//
//  UIImageView+WBAdditional.h
//  Pods
//
//  Created by WenBo on 2019/11/20.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBUIViewContentMode) {
    WBUIViewContentModeScaleToFill,
    WBUIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    WBUIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    WBUIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
    WBUIViewContentModeCenter,              // contents remain same size. positioned adjusted.
    WBUIViewContentModeTop,
    WBUIViewContentModeBottom,
    WBUIViewContentModeLeft,
    WBUIViewContentModeRight,
    WBUIViewContentModeTopLeft,
    WBUIViewContentModeTopRight,
    WBUIViewContentModeBottomLeft,
    WBUIViewContentModeBottomRight,
    ///自定义裁剪样式
    WBUIViewContentModeScaleAspectFitTop,
    WBUIViewContentModeScaleAspectFitBottom,
    WBUIViewContentModeScaleAspectFitLeft,
    WBUIViewContentModeScaleAspectFitRight
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (WBAdditional)

/// 自定义的裁剪方式，已兼容`UIImageView`的`contentMode`属性，直接使用`wb_contentMode`属性即可，需避免两者同时使用。
@property (nonatomic, assign) WBUIViewContentMode wb_contentMode;

@end

NS_ASSUME_NONNULL_END
