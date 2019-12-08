//
//  NSString+WBAddtional.h
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WBAdditional)

#pragma mark - 字符串处理

/// remove white spaces
- (NSString *)wb_trim;

/// remove white spaces
- (NSString *)wb_removeWhiteSpacesFromString;

/// 把该字符串转换为对应的 md5
@property (readonly, copy) NSString *wb_md5;

/// 把当前文本的第一个字符改为大写，其他的字符保持不变，例如 backgroundView.wb_capitalizedString -> BackgroundView（系统的 capitalizedString 会变成 Backgroundview）
- (NSString *)wb_capitalizedString;

/// 将字符串按一个一个字符拆成数组，类似 JavaScript 里的 split("")，如果多个空格，则每个空格也会当成一个 item
@property (nullable, readonly, copy) NSArray<NSString *> *wb_toArray;

/// 将字符串按一个一个字符拆成数组，类似 JavaScript 里的 split("")，但会自动过滤掉空白字符
@property (nullable, readonly, copy) NSArray<NSString *> *wb_toTrimmedArray;

/// 去掉整段文字内的所有空白字符（包括换行符）
@property (readonly, copy) NSString *wb_trimAllWhiteSpace;

/// 将文字中的换行符替换为空格
@property (readonly, copy) NSString *wb_trimLineBreakCharacter;

/// 返回一个符合 query value 要求的编码后的字符串，例如&、#、=等字符均会被变为 %xxx 的编码
@property (nullable, readonly, copy) NSString *wb_stringByEncodingUserInputQuery;

/// 用正则表达式匹配的方式去除字符串里一些特殊字符，避免UI上的展示问题
/// @link http://www.croton.su/en/uniblock/Diacriticals.html
/// @/link
@property (nullable, readonly, copy) NSString *wb_removeMagicalChar;

/// 按照中文 2 个字符、英文 1 个字符的方式来计算文本长度
@property (readonly) NSUInteger wb_lengthWhenCountingNonASCIICharacterAsTwo;

/// 将字符串从指定的 index 开始裁剪到结尾，裁剪时会避免将 emoji 等 "character sequences" 拆散（一个 emoji 表情占用1-4个长度的字符）。
/// 例如对于字符串“😊😞”，它的长度为4，若调用 [string wb_substringAvoidBreakingUpCharacterSequencesFromIndex:1]，将返回“😊😞”。
/// 若调用系统的 [string substringFromIndex:1]，将返回“?😞”。（?表示乱码，因为第一个 emoji 表情被从中间裁开了）。
/// @param index 要从哪个 index 开始裁剪文字
/// @param lessValue 要按小的长度取，还是按大的长度取
/// @param countingNonASCIICharacterAsTwo  是否按照 英文 1 个字符长度、中文 2 个字符长度的方式来裁剪
- (NSString *)wb_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index
                                                           lessValue:(BOOL)lessValue
                                      countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;

/// 相当于 `wb_substringAvoidBreakingUpCharacterSequencesFromIndex: lessValue:YES` countingNonASCIICharacterAsTwo:NO
/// @param index 要从哪个 index 开始裁剪文字
/// @see wb_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo
- (NSString *)wb_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index;

/// 将字符串从开头裁剪到指定的 index，裁剪时会避免将 emoji 等 "character sequences" 拆散（一个 emoji 表情占用1-4个长度的字符）。
/// 例如对于字符串“😊😞”，它的长度为4，若调用 [string wb_substringAvoidBreakingUpCharacterSequencesToIndex:1 lessValue:NO countingNonASCIICharacterAsTwo:NO]，将返回“😊”。
/// 若调用系统的 [string substringToIndex:1]，将返回“?”。（?表示乱码，因为第一个 emoji 表情被从中间裁开了）。
/// @param index 要裁剪到哪个 index
/// @param lessValue 裁剪时若遇到“character sequences”，是向下取整还是向上取整。
/// @param countingNonASCIICharacterAsTwo countingNonASCIICharacterAsTwo 是否按照 英文 1 个字符长度、中文 2 个字符长度的方式来裁剪
- (NSString *)wb_substringAvoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index
                                                         lessValue:(BOOL)lessValue
                                    countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;

/// 相当于 `wb_substringAvoidBreakingUpCharacterSequencesToIndex:lessValue:YES` countingNonASCIICharacterAsTwo:NO
/// @param index 要裁剪到哪个 index
- (NSString *)wb_substringAvoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index;

/// 将字符串里指定 range 的子字符串裁剪出来，会避免将 emoji 等 "character sequences" 拆散（一个 emoji 表情占用1-4个长度的字符）。
/// 例如对于字符串“😊😞”，它的长度为4，在 lessValue 模式下，裁剪 (0, 1) 得到的是空字符串，裁剪 (0, 2) 得到的是“😊”。
/// 在非 lessValue 模式下，裁剪 (0, 1) 或 (0, 2)，得到的都是“😊”。
/// @param range 要裁剪的文字位置
/// @param lessValue 裁剪时若遇到“character
/// @param countingNonASCIICharacterAsTwo countingNonASCIICharacterAsTwo 是否按照 英文 1 个字符长度、中文 2 个字符长度的方式来裁剪
- (NSString *)wb_substringAvoidBreakingUpCharacterSequencesWithRange:(NSRange)range
                                                           lessValue:(BOOL)lessValue
                                      countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;

/// 相当于 `wb_substringAvoidBreakingUpCharacterSequencesWithRange:lessValue:YES` countingNonASCIICharacterAsTwo:NO
/// @param range 要裁剪的文字位置
- (NSString *)wb_substringAvoidBreakingUpCharacterSequencesWithRange:(NSRange)range;

/// 移除指定位置的字符，可兼容emoji表情的情况（一个emoji表情占1-4个length）
/// @param index 要删除的位置
- (NSString *)wb_stringByRemoveCharacterAtIndex:(NSUInteger)index;

/// 移除最后一个字符，可兼容emoji表情的情况（一个emoji表情占1-4个length）
- (NSString *)wb_stringByRemoveLastCharacter;

/// 用正则表达式匹配字符串，将匹配到的第一个结果返回，大小写不敏感
/// @param pattern 匹配到的第一个结果，如果没有匹配成功则返回 nil
- (NSString *)wb_stringMatchedByPattern:(NSString *)pattern;

/// 用正则表达式匹配字符串并将其替换为指定的另一个字符串，大小写不敏感
/// @param pattern pattern 正则表达式
/// @param replacement 要替换为的字符串
- (NSString *)wb_stringByReplacingPattern:(NSString *)pattern
                               withString:(NSString *)replacement;

/// 将秒数转换为同时包含分钟和秒数的格式的字符串，例如 100->"01:40"
/// @param seconds 秒数 eg: 60s
+ (NSString *)wb_timeStringWithMinsAndSecsFromSecs:(double)seconds;

#pragma mark - 计算文字大小
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

#pragma mark - 隐藏部分文字
/**
 *  隐藏部分文字 "*"代替
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

#pragma mark - Transform
/// 金额转大写
/// @param money 金额
+ (NSString *)wb_digitUppercaseWithMoney:(NSString *)money;

/**
 Try to parse this string and returns an `NSNumber`.
 @return Returns an `NSNumber` if parse succeed, or nil if an error occurs.
 */
- (NSNumber *)wb_numberValue;

/// Returns an NSData using UTF-8 encoding.
- (NSData *)wb_dataValue;

/// Returns an NSDictionary/NSArray which is decoded from receiver.
/// Returns nil if an error occurs.
/// e.g. NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
- (id)wb_jsonValueDecoded;

/// 格式化浮点数，最多保留两位小数
/// @param floatValue 浮点数
+ (NSString *)wb_formatFloat:(float)floatValue;

/// 获取浮点数格式
/// @param floatValue 浮点数
+ (NSString *)wb_getFloatFormat:(float)floatValue;

/// 格式化浮点数，解决精度丢失问题
/// @param doubleValue doubleValue description
+ (NSString *)wb_formattingDoubleValue:(double)doubleValue;

#pragma mark - Common Method
/// Returns NSMakeRange(0, self.length).
- (NSRange)wb_rangeOfAll;

/// 获取文字所占所占行数
/// @param width 宽度
/// @param font 字体
- (NSUInteger)wb_getNeedLinesWithLimitWidth:(CGFloat)width
                                       font:(UIFont *)font;

#pragma mark - File Path
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

/**
 Create upload file name.

 @return random string.
 */
- (NSString *)wb_createFileName;

@end

@interface NSString (WBStringFormat)

+ (instancetype)wb_stringWithNSInteger:(NSInteger)integerValue;
+ (instancetype)wb_stringWithCGFloat:(CGFloat)floatValue;
+ (instancetype)wb_stringWithCGFloat:(CGFloat)floatValue decimal:(NSUInteger)decimal;

@end

NS_ASSUME_NONNULL_END
