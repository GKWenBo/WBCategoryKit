//
//  UIImage+WB_Additional.h
//  WB_UIImageUtility
//
//  Created by WMB on 2017/6/15.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBHelper.h"

#ifdef DEBUG
    #define WBCGContextInspectContext(context) [WBHelper wb_inspectContextIfInvalidatedInDebugMode:context]
#else
    #define WBCGContextInspectContext(context) if(![WBHelper wb_inspectContextIfInvalidatedInReleaseMode:context]){return nil;}
#endif

NS_ASSUME_NONNULL_BEGIN
@interface UIImage (WBAdditional)

#pragma mark --------  Create Image <PDF、Path、NSData 、GIF、View>  --------
/**
 Create an image from a PDF file data or path.
 
 @discussion If the PDF has multiple page, is just return's the first page's
 content. Image's scale is equal to current screen's scale, size is same as
 PDF's origin size.
 
 @param dataOrPath PDF data in `NSData`, or PDF file path in `NSString`.
 
 @return A new image create from PDF, or nil when an error occurs.
 */
+ (nullable UIImage *)wb_imageWithPDF:(id)dataOrPath;
/**
 Create an image from a PDF file data or path.
 
 @discussion If the PDF has multiple page, is just return's the first page's
 content. Image's scale is equal to current screen's scale.
 
 @param dataOrPath  PDF data in `NSData`, or PDF file path in `NSString`.
 
 @param size     The new image's size, PDF's content will be stretched as needed.
 
 @return A new image create from PDF, or nil when an error occurs.
 */
+ (nullable UIImage *)wb_imageWithPDF:(id)dataOrPath
                                 size:(CGSize)size;

/**
 Create and return an image with custom draw code.
 
 @param size      The image size.
 @param drawBlock The draw block.
 
 @return The new image.
 */
+ (nullable UIImage *)wb_imageWithSize:(CGSize)size
                             drawBlock:(void (^)(CGContextRef context))drawBlock;

/**
 全屏截图

 @return 全屏截图图片
 */
+ (UIImage *)wb_shotScreen;

/**
 截取view生成一张图片

 @param view 截取的视图
 @return 视图截取生成的图片
 */
+ (UIImage *)wb_shotWithView:(UIView *)view;

/**
 截取view中某个区域生成一张图片

 @param view 要截取的视图
 @param scope 截取范围
 @return 截取生成的图片
 */
+ (UIImage *)wb_shotWithView:(UIView *)view
                       scope:(CGRect)scope;

/**
 拉伸图片指定区域

 @param insets 拉伸范围
 @return 拉伸后的图片
 */
- (UIImage *)wb_resizableImageWithInsets:(UIEdgeInsets)insets;

/**
 比例调整图片

 @param scale 比例
 @return image
 */
- (UIImage *)wb_imageByResizeToScale:(CGFloat)scale;

/**
 根据电影地址获取图片

 @param videoURL 电影地址
 @return 电影图片
 */
+ (UIImage *)wb_getVideoImage:(NSURL *)videoURL;

#pragma mark --------  Modify Image  --------
CGRect WBCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);
/**
 Draws the entire image in the specified rectangle, content changed with
 the contentMode.
 
 @discussion This method draws the entire image in the current graphics context,
 respecting the image's orientation setting. In the default coordinate system,
 images are situated down and to the right of the origin of the specified
 rectangle. This method respects any transforms applied to the current graphics
 context, however.
 
 @param rect        The rectangle in which to draw the image.
 
 @param contentMode Draw content mode
 
 @param clips       A Boolean value that determines whether content are confined to the rect.
 */
- (void)wb_drawInRect:(CGRect)rect
      withContentMode:(UIViewContentMode)contentMode
        clipsToBounds:(BOOL)clips;
/**
 Returns a new image which is scaled from this image.
 The image will be stretched as needed.
 
 @param size  The new size to be scaled, values should be positive.
 
 @return The new image with the given size.
 */
- (nullable UIImage *)wb_imageByResizeToSize:(CGSize)size;
/**
 Returns a new image which is scaled from this image.
 The image content will be changed with thencontentMode.
 
 @param size        The new size to be scaled, values should be positive.
 
 @param contentMode The content mode for image content.
 
 @return The new image with the given size.
 */
- (nullable UIImage *)wb_imageByResizeToSize:(CGSize)size
                                 contentMode:(UIViewContentMode)contentMode;
/**
 Returns a new image which is cropped from this image.
 
 @param rect  Image's inner rect.
 
 @return      The new image, or nil if an error occurs.
 */
- (nullable UIImage *)wb_imageByCropToRect:(CGRect)rect;

/**
 Return a new image which is resize from this image.
 
 @param image origin image
 @param targetSize targetSize
 @return The new image, or nil if an error occurs.
 */
+ (nullable UIImage *)wb_image:(UIImage *)image
                 forTargetSize:(CGSize)targetSize;

#pragma mark --------  Border And CornerRadius  --------
/**
 Returns a new image which is edge inset from this image.
 
 @param insets  Inset (positive) for each of the edges, values can be negative to 'outset'.
 
 @param color   Extend edge's fill color, nil means clear color.
 
 @return        The new image, or nil if an error occurs.
 */
- (nullable UIImage *)wb_imageByInsetEdge:(UIEdgeInsets)insets
                                withColor:(nullable UIColor *)color;
/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.
 
 @param borderColor  The border stroke color. nil means clear color.
 */
- (nullable UIImage *)wb_imageByRoundCornerRadius:(CGFloat)radius
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor;
/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.
 
 @param corners      A bitmask value that identifies the corners that you want
 rounded. You can use this parameter to round only a subset
 of the corners of the rectangle.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.
 
 @param borderColor  The border stroke color. nil means clear color.
 
 @param borderLineJoin The border line join.
 */
- (nullable UIImage *)wb_imageByRoundCornerRadius:(CGFloat)radius
                                          corners:(UIRectCorner)corners
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor
                                   borderLineJoin:(CGLineJoin)borderLineJoin;

/// 切割出在指定圆角的图片
/// @param cornerRadius 要切割的圆角值
- (nullable UIImage *)wb_imageWithClippedCornerRadius:(CGFloat)cornerRadius;

/// 切割出在指定圆角的图片
/// @param cornerRadius 要切割的圆角值
/// @param scale 比例
- (nullable UIImage *)wb_imageWithClippedCornerRadius:(CGFloat)cornerRadius
                                                scale:(CGFloat)scale;


// MARK: -------- UIImage Effect
/// 获取当前图片的像素大小，如果是多倍图，会被放大到一倍来算
@property(nonatomic, assign, readonly) CGSize wb_sizeInPixel;
///判断一张图是否不存在 alpha 通道，注意 “不存在 alpha 通道” 不等价于 “不透明”。一张不透明的图有可能是存在 alpha 通道但 alpha 值为 1。
- (BOOL)wb_opaque;

/// 获取当前图片的均色，原理是将图片绘制到1px*1px的矩形内，再从当前区域取色，得到图片的均色。
- (UIColor *)wb_averageColor;

/// 置灰当前图片
- (nullable UIImage *)wb_grayImage;

/// 设置一张图片的透明度
/// @param alpha 透明度值
- (nullable UIImage *)wb_imageWithAlpha:(CGFloat)alpha;

/// 保持当前图片的形状不变，使用指定的颜色去重新渲染它，生成一张新图片并返回
/// @param tintColor 要用于渲染的新颜色
- (nullable UIImage *)wb_imageWithTintColor:(nullable UIColor *)tintColor;

/**
 Create and return a 1x1 point size image with the given color.
 
 @param color  The color.
 */
+ (nullable UIImage *)wb_imageWithColor:(UIColor *)color;

/**
 Create and return a pure color image with the given color and size.
 
 @param color  The color.
 @param size   New image's type.
 */
+ (nullable UIImage *)wb_imageWithColor:(UIColor *)color
                                   size:(CGSize)size;

/**
 Tint the image in alpha channel with the given color.
 
 @param color  The color.
 */
- (nullable UIImage *)wb_imageByTintColor:(UIColor *)color;

/**
 Returns a grayscaled image.
 */
- (nullable UIImage *)wb_imageByGrayscale;

/**
 Applies a blur effect to this image. Suitable for blur any content.
 */
- (nullable UIImage *)wb_imageByBlurSoft;

/**
 Applies a blur effect to this image. Suitable for blur any content except pure white.
 (same as iOS Control Panel)
 */
- (nullable UIImage *)wb_imageByBlurLight;

/**
 Applies a blur effect to this image. Suitable for displaying black text.
 (same as iOS Navigation Bar White)
 */
- (nullable UIImage *)wb_imageByBlurExtraLight;

/**
 Applies a blur effect to this image. Suitable for displaying white text.
 (same as iOS Notification Center)
 */
- (nullable UIImage *)wb_imageByBlurDark;

/**
 Applies a blur and tint color to this image.
 
 @param tintColor  The tint color.
 */
- (nullable UIImage *)wb_imageByBlurWithTint:(UIColor *)tintColor;

/**
 Applies a blur, tint color, and saturation adjustment to this image,
 optionally within the area specified by @a maskImage.
 
 @param blurRadius     The radius of the blur in points, 0 means no blur effect.
 
 @param tintColor      An optional UIColor object that is uniformly blended with
 the result of the blur and saturation operations. The
 alpha channel of this color determines how strong the
 tint is. nil means no tint.
 
 @param tintBlendMode  The @a tintColor blend mode. Default is kCGBlendModeNormal (0).
 
 @param saturation     A value of 1.0 produces no change in the resulting image.
 Values less than 1.0 will desaturation the resulting image
 while values greater than 1.0 will have the opposite effect.
 0 means gray scale.
 
 @param maskImage      If specified, @a inputImage is only modified in the area(s)
 defined by this mask.  This must be an image mask or it
 must meet the requirements of the mask parameter of
 CGContextClipToMask.
 
 @return               image with effect, or nil if an error occurs (e.g. no
 enough memory).
 */
- (nullable UIImage *)imageByBlurRadius:(CGFloat)blurRadius
                              tintColor:(nullable UIColor *)tintColor
                               tintMode:(CGBlendMode)tintBlendMode
                             saturation:(CGFloat)saturation
                              maskImage:(nullable UIImage *)maskImage;

/**
 滤镜

 @param image 原图
 @param name
 // 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
 // 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
 // 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
 // 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
 // CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField

 @return 滤镜过后的图片
 */
+ (UIImage *)wb_filterWithOriginalImage:(UIImage *)image
                             filterName:(NSString *)name;

/**
 对图片进行模糊处理 <貌似很耗内存>

 @param image 原图
 @param name 模糊效果
 // CIGaussianBlur ---> 高斯模糊
 // CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
 // CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
 // CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
 // CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
 @param radius 圆角大小
 @return 模糊效果图片
 */
+ (UIImage *)wb_blurWithOriginalImage:(UIImage *)image
                             blurName:(NSString *)name
                               radius:(NSInteger)radius;


/**
 调整图片饱和度, 亮度, 对比度

 @param image 目标图片
 @param saturation 饱和度
 @param brightness 亮度: -1.0 ~ 1.0
 @param contrast 对比度
 @return 调整过后的图片
 */
+ (UIImage *)wb_colorControlsWithOriginalImage:(UIImage *)image
                                    saturation:(CGFloat)saturation
                                    brightness:(CGFloat)brightness
                                      contrast:(CGFloat)contrast;
/**
 *  图片模糊效果
 *
 *  @param blurAmount 0.0 - 1.0
 *  @return image
 */
- (UIImage *)wb_blurredImage:(CGFloat)blurAmount;

@end
NS_ASSUME_NONNULL_END
