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
#pragma mark
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
#pragma mark
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
#pragma mark
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
 *  @return YES OR NO
 */
+ (BOOL)wb_checkPostCode:(NSString *)str;

@end
