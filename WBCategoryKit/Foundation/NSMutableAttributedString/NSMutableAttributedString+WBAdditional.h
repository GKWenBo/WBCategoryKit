//
//  NSMutableAttributedString+WBAdditional.h
//  Pods-WBCategoryKit_Example
//
//  Created by Mr_Lucky on 2018/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (WBAdditional)

/**
 设置富文本样式font、textColor、lineSpacing、alignment、lineBreakMode

 @param font 字体a样式
 @param textColor 文字颜色
 @param lineSpacing 行间距
 @param alignment 对齐方式
 @param lineBreakMode 结尾部分的内容格式
 */
- (void)wb_makeAttributeWithFont:(UIFont *)font
                       textColor:(UIColor *)textColor
                     lineSpacing:(CGFloat)lineSpacing
                       alignment:(NSTextAlignment)alignment
                   lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 设置富文本样式font、textColor、lineSpacing、alignment、lineBreakMode、range
 
 @param font 字体a样式
 @param textColor 文字颜色
 @param lineSpacing 行间距
 @param alignment 对齐方式
 @param lineBreakMode 结尾部分的内容格式
 @param range 设置范围
 */
- (void)wb_makeAttributeWithFont:(UIFont *)font
                       textColor:(UIColor *)textColor
                     lineSpacing:(CGFloat)lineSpacing
                       alignment:(NSTextAlignment)alignment
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                           range:(NSRange)range;


/**
 设置富文本样式font、textColor、lineSpacing、alignment、lineBreakMode、range、paragraphSpacing、paragraphSpacing、headIndent

 @param font 字体大小
 @param textColor 文字颜色
 @param lineSpacing 行间距
 @param alignment 对齐方式
 @param lineBreakMode 结尾部分的内容格式
 @param paragraphSpacing 段落间距
 @param firstLineHeadIndent 首行缩进
 @param headIndent 头部整体缩进
 @param range 范围
 */
- (void)wb_makeAttributeWithFont:(UIFont *)font
                       textColor:(UIColor *)textColor
                     lineSpacing:(CGFloat)lineSpacing
                       alignment:(NSTextAlignment)alignment
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                paragraphSpacing:(CGFloat)paragraphSpacing
             firstLineHeadIndent:(CGFloat)firstLineHeadIndent
                      headIndent:(CGFloat)headIndent

                           range:(NSRange)range;

/**
 设置富文本样式font、textColor、lineSpacing、lineBreakMode、range
 
 @param font 字体a样式
 @param textColor 文字颜色
 @param lineSpacing 行间距
 @param lineBreakMode 结尾部分的内容格式
 @param range 设置范围
 */
- (void)wb_makeAttributeWithFont:(UIFont *)font
                       textColor:(UIColor *)textColor
                     lineSpacing:(CGFloat)lineSpacing
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                           range:(NSRange)range;

/**
 插入图片

 @param image y图片
 @param bounds 大小
 @param index 插入位置下标
 */
- (void)wb_makeAttributeWithImage:(UIImage *)image
                           bounds:(CGRect)bounds
                          atIndex:(NSInteger)index;

/**
 添加下划线

 @param style 下划线样式
 */
- (void)wb_makeUnderLineWithStyle:(NSNumber *)style;

/**
 添加下划线，并设置范围

 @param style 下划线样式
 @param range 范围
 */
- (void)wb_makeUnderLineWithStyle:(NSNumber *)style
                            range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
