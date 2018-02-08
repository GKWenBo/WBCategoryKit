//
//  UIImage+WB_Effect.h
//  WB_UIImageUtility
//
//  Created by WMB on 2017/6/16.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIImage (WBEffect)

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
