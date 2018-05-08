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

#pragma mark --------  随机色  --------
#pragma mark
+ (UIColor *)wb_randomColor;

#pragma mark --------  RGB/RGBA  --------
#pragma mark
/**
 *  RGBA颜色
 *
 *  @param red 红色
 *  @param green 绿色
 *  @param blue 蓝色
 *  @param alpha 透明度
 *  @return RGBA颜色
 */
+ (UIColor *)wb_rgbaColorWithRed:(CGFloat)red
                           green:(CGFloat)green
                            blue:(CGFloat)blue
                           alpha:(CGFloat)alpha;
+ (UIColor *)wb_rgbColorWithRed:(CGFloat)red
                          green:(CGFloat)green
                           blue:(CGFloat)blue;

#pragma mark --------  Hex Color  --------
#pragma mark
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

/**
 *  获取hex字符串
 *  @return hex字符串
 */
- (NSString *)wb_getHexString;

#pragma mark --------  渐变色  --------
#pragma mark
+ (UIColor*)wb_gradientFromColor:(UIColor *)c1
                         toColor:(UIColor *)c2
                      withHeight:(int)height;

@end
NS_ASSUME_NONNULL_END
