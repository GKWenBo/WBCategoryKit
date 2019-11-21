//
//  UIColor+WB_Additional.h
//  UIColorUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (WBAdditional)

/// 获取当前 UIColor 对象里的透明色值 透明通道的色值，值范围为0.0-1.0
- (CGFloat)wb_alpha;

#pragma mark --------  随机色  --------
/// 获取随机色
+ (UIColor *)wb_randomColor;

#pragma mark --------  RGB/RGBA  --------
/// RGBA颜色
/// @param red 红色
/// @param green 绿色
/// @param blue 蓝色
/// @param alpha 透明度
+ (UIColor *)wb_rgbaColorWithRed:(CGFloat)red
                           green:(CGFloat)green
                            blue:(CGFloat)blue
                           alpha:(CGFloat)alpha;
+ (UIColor *)wb_rgbColorWithRed:(CGFloat)red
                          green:(CGFloat)green
                           blue:(CGFloat)blue;

/// 得到一个颜色的原始值 RGBA
- (NSArray <NSNumber *>*)wb_getRGBDictionary;
- (CGFloat *)wb_getRGB;

/// 得到两个值的色差
/// @param beginColor 起始颜色
/// @param endColor 终止颜色
+ (NSArray <NSNumber *>*)wb_transColorWithBeginColor:(UIColor *)beginColor
                                            endColor:(UIColor *)endColor;

/// 获取当前 UIColor 对象里的 saturation（饱和度）
- (CGFloat)wb_saturation;

/// 获取当前 UIColor 对象里的 brightness（亮度）
- (CGFloat)wb_brightness;

/// 将当前UIColor对象剥离掉alpha通道后得到的色值。相当于把当前颜色的半透明值强制设为1.0后返回
- (nullable UIColor *)wb_colorWithoutAlpha;

/// 计算当前color叠加了alpha之后放在指定颜色的背景上的色值
/// @param alpha 透明度
/// @param backgroundColor 指定背景色
- (UIColor *)wb_colorWithAlpha:(CGFloat)alpha
               backgroundColor:(nullable UIColor *)backgroundColor;

/// 计算两个颜色叠加之后的最终色（注意区分前景色后景色的顺序）<br/>
/// @param backendColor backendColor description
/// @param frontColor frontColor description
/// @link http://stackoverflow.com/questions/10781953/determine-rgba-colour-received-by-combining-two-colours
+ (UIColor *)wb_colorWithBackendColor:(UIColor *)backendColor
                           frontColor:(UIColor *)frontColor;

/// 计算当前color叠加了alpha之后放在白色背景上的色值
/// @param alpha 透明度
- (UIColor *)wb_colorWithAlphaAddedToWhite:(CGFloat)alpha;

#pragma mark -------- Hex Color
/**
 *  从十六进制字符串获取颜色
 *
 *  @param color 支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *  @param alpha 颜色透明度
 *  @return 十六进制颜色
 */
+ (UIColor *)wb_colorWithHexString:(NSString *)color
                             alpha:(CGFloat)alpha;
+ (UIColor *)wb_colorWithHexString:(NSString *)color;

/**
 *  Creates and returns a color object using the hex RGB color values
 *
 *  @param rgbValue 0x66ccff
 *  @return hex RGB color
 *  @return The color object
 */
+ (UIColor *)wb_colorWithRGB:(uint32_t)rgbValue;

/**
 *  Creates and returns a color object using the hex RGBA color values.
 *
 *  @param rgbaValue 0x66ccffff
 *  @return The color object
 */
+ (UIColor *)wb_colorWithRGBA:(uint32_t)rgbaValue;

/**
 *  Creates and returns a color object using the specified opacity and RGB hex value
 *
 *  @param rgbValue 0x66CCFF
 *  @param alpha The opacity value of the color object
 *  @return The color object
 */
+ (UIColor *)wb_colorWithRGB:(uint32_t)rgbValue
                       alpha:(CGFloat)alpha;

/// 获取hex字符串
- (NSString *)wb_getHexString;

#pragma mark -------- 渐变色
/// 创建渐变颜色
/// @param c1 起始颜色
/// @param c2 终止颜色
/// @param startPoint 渐变起始点
/// @param endPoint 渐变结束点
+ (UIColor *)wb_gradientFromColor:(UIColor *)c1
                          toColor:(UIColor *)c2
                       startPoint:(CGPoint)startPoint
                         endPoint:(CGPoint)endPoint;

/// 颜色渐变过渡
/// @param beginColor 开始颜色
/// @param endColor 终止颜色
/// @param ratio 系数（0-1）
+ (UIColor *)wb_getGradientColorWithBeginColor:(UIColor *)beginColor
                                      endColor:(UIColor *)endColor
                                         ratio:(double)ratio;

// MARK: -------- Utility

/// 判断当前颜色是否为深色，可用于根据不同色调动态设置不同文字颜色的场景。
/// @link http://stackoverflow.com/questions/19456288/text-color-based-on-background-image
/// @/link
- (BOOL)wb_colorIsDark;

/// 判断当前颜色是否等于系统默认的 tintColor 颜色。
/// 背景：如果将一个 UIView.tintColor 设置为 nil，表示这个 view 的 tintColor 希望跟随 superview.tintColor 变化而变化，所以设置完再获取 view.tintColor，得到的并非 nil，而是 superview.tintColor 的值，而如果整棵 view 层级树里的 view 都没有设置自己的 tintColor，则会返回系统默认的 tintColor（也即 [UIColor qmui_systemTintColor]），所以才提供这个方法用于代替判断 tintColor == nil 的作用。
- (BOOL)wb_isSystemTintColor;
/// 获取当前系统的默认 tintColor 色值
+ (UIColor *)wb_systemTintColor;

@end
NS_ASSUME_NONNULL_END
