//
//  NSString+WBPredicate.h
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WBPredicate)
#pragma mark -- 字符串处理
/**
 *  remove white spaces
 *
 */
- (NSString *)wb_trim;
/**
 *  remove white spaces
 *
 */
- (NSString *)wb_removeWhiteSpacesFromString;

#pragma mark -- 字符串判断
/**
 *  判断字符串是否为空
 *
 */
- (BOOL)wb_isBlank;
/**
 *  判断字符串是否为NULL
 *
 */
- (BOOL)wb_isNull;

/**
 *  判断是否为空字符串
 *
 */
+ (BOOL)wb_isNull:(NSString *)object;

/**
 Returns YES if the target string is contained within the receiver.
 @param string A string to test the the receiver.
 
 @discussion Apple has implemented this method in iOS8.
 */
- (BOOL)wb_containsString:(NSString *)string;

#pragma mark -- 字符串验证
/**
 *  验证邮箱是否正确
 *
 */
- (BOOL)wb_isValidEmail;
/**
 *  验证手机号是否正确
 *
 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
 联通：130,131,132,152,155,156,185,186
 电信：133,1349,153,180,189,181(增加)
 */
- (BOOL)wb_isValidMobile;
//- (BOOL)wb_isValidMobile;

/**
 *  身份证是否正确
 *
 */
- (BOOL)wb_isValidIdentityCard;
+ (BOOL)wb_validateIdentityCard:(NSString *)identityCard;

/**
 *  验证码是否正确，位数可自行制定
 *
 */
- (BOOL)wb_isValidVerifyCode;

/**
 *  有效中文姓名
 *
 */
- (BOOL)wb_isValidRealName;

/**
 *  有效密码（6-12位）
 *
 */
- (BOOL)wb_isValidAlphaNumberPassword;

/**
 *  是否只有中文
 *
 */
- (BOOL)wb_isOnlyChinese;

/**
 *  验证银行卡号
 *
 *  @param cardNo 银行卡
 *  @return YES OR NO
 */
+ (BOOL)wb_checkCardNo:(NSString *)cardNo;

/**
 *  验证微信号
 *
 *  @param wxNumber 微信号
 *  @return YES OR NO
 */
+ (BOOL)wb_isValidWXNumber:(NSString * )wxNumber;

/**
 *  判断邮编是否正确
 *
 *  @param str 邮编
 *  @return YES/NO
 */
+ (BOOL)wb_checkPostCode:(NSString *)str;

/**
 字符串比较

 @param str 要比较的字符串
 @param result 比较类型
 @return YES/NO
 */
- (BOOL)wb_compare:(NSString *)str
        withResult:(NSComparisonResult)result;

/**
 字符串比较

 @param str 要比较的字符串
 @param result 比较类型
 @param options 条件
 
 NSCaseInsensitiveSearch = 1,    //不区分大小写比较
 NSLiteralSearch = 2,    //逐字节比较 区分大小写
 NSBackwardsSearch = 4,    //从字符串末尾开始搜索
 NSAnchoredSearch = 8,    //搜索限制范围的字符串
 NSNumericSearch = 64,    //按照字符串里的数字为依据，算出顺序。例如 Foo2.txt < Foo7.txt < Foo25.txt
 NSDiacriticInsensitiveSearchNS_ENUM_AVAILABLE(10_5, 2_0) = 128,//忽略 "-" 符号的比较
 NSWidthInsensitiveSearchNS_ENUM_AVAILABLE(10_5, 2_0) = 256,//忽略字符串的长度，比较出结果
 NSForcedOrderingSearchNS_ENUM_AVAILABLE(10_5, 2_0) = 512,//忽略不区分大小写比较的选项，并强制返回 NSOrderedAscending 或者 NSOrderedDescending
 NSRegularExpressionSearchNS_ENUM_AVAILABLE(10_7, 3_2) = 1024   //只能应用于 rangeOfString:..., stringByReplacingOccurrencesOfString:...和 replaceOccurrencesOfString:... 方法。使用通用兼容的比较方法，如果设置此项，可以去掉 NSCaseInsensitiveSearch 和 NSAnchoredSearch
 @return YES/NO
 */
- (BOOL)wb_compare:(NSString *)str
        withResult:(NSComparisonResult)result
           options:(NSStringCompareOptions)options;

@end
