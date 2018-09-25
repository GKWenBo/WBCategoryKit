//
//  NSString+WBAddtional.h
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (WBAddtional)
#pragma mark --------  计算文字大小  --------
/**
 *  计算文字size
 *
 *  @param size 限制size
 *  @param font 字体
 *  @param lineBreakMode 换行格式
 *  @return 文字size
 */
- (CGSize)wb_sizeForFont:(UIFont *)font
                    size:(CGSize)size
                    mode:(NSLineBreakMode)lineBreakMode;
/**
 Returns the width of the string if it were to be rendered with the specified
 font on a single line.
 
 @param font  The font to use for computing the string width.
 
 @return      The width of the resulting string's bounding box. These values may be
 rounded up to the nearest whole number.
 */
- (CGFloat)wb_widthForFont:(UIFont *)font;

/**
 Returns the height of the string if it were rendered with the specified constraints.
 
 @param font   The font to use for computing the string size.
 
 @param width  The maximum acceptable width for the string. This value is used
 to calculate where line breaks and wrapping would occur.
 
 @return       The height of the resulting string's bounding box. These values
 may be rounded up to the nearest whole number.
 */
- (CGFloat)wb_heightForFont:(UIFont *)font
                      width:(CGFloat)width;

#pragma mark --------  隐藏部分文字  --------
/**
 *  隐藏部分文字
 *
 *  @param number 数字字符串
 *  @param headerLength 头部不隐藏长度
 *  @param footerLength 尾部不隐藏长度
 */
+ (NSString *)wb_hidePartCharacterWithNumberStr:(NSString *)number
                                   headerLength:(NSInteger)headerLength
                                   footerLength:(NSInteger)footerLength;
/**
 *  身份证号显示前3后4位中间以星号显示
 *
 *  @param IDCardNumber 身份证号
 */
+ (NSString *)wb_disposeIDCardNumber:(NSString *)IDCardNumber;

#pragma mark --------  Transform  --------
/**
 *  金额转大写
 *
 *  @param money 金额
 *  @return 大写金额
 */
+ (NSString *)wb_digitUppercaseWithMoney:(NSString *)money;

/**
 Try to parse this string and returns an `NSNumber`.
 @return Returns an `NSNumber` if parse succeed, or nil if an error occurs.
 */
- (NSNumber *)wb_numberValue;

/**
 Returns an NSData using UTF-8 encoding.
 */
- (NSData *)wb_dataValue;

/**
 Returns an NSDictionary/NSArray which is decoded from receiver.
 Returns nil if an error occurs.
 
 e.g. NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (id)wb_jsonValueDecoded;

#pragma mark --------  Common Method  --------
/**
 Returns NSMakeRange(0, self.length).
 */
- (NSRange)wb_rangeOfAll;

#pragma mark ------ < File Path > ------
/**
 *  获取Document文件夹
 *  @return Document路径
 */
+ (NSString *)wb_getDocumentPath;

/**
 *  获取Library/Caches
 *  @return Library/Caches路径
 */
+ (NSString *)wb_getLibraryCaches;

@end
