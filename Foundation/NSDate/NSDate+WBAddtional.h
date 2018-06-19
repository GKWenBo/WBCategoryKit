//
//  NSDate+WB_Time.h
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBDateHeaderFile.h"

@interface NSDate (WBAddtional)

#pragma mark -- DateString
/**
 *  获取当前时间
 *
 *  @param format @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
  *  @return yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)wb_currentDateWithFormat:(NSString *)format;

/**
 *  通过时间戳得出时间字符串
 *
 *  @param timestamp 时间戳
 *  @param formatter 时间格式
 *  @return 时间字符串
 */
+ (NSString *)wb_getStringWithTimestamp:(NSTimeInterval)timestamp
                              formatter:(NSString*)formatter;
+ (NSString *)wb_getStringByTimestamp:(NSTimeInterval)timeStamp
                               format:(NSString *)format;

/**
 *  根据时间戳（如@"1447400310"）返回一个字符串（如2015-11-12）
 *
 *  @param timestampStr 如： @"1447400310"
 *  @param dateFormatter @"yyyy-MM-dd"
 *  @return 2015-11-12
 */
+ (NSString *)wb_timestampToTimeStrWithTimestampStr:(NSString *)timestampStr
                                      dateFormatter:(NSString *)dateFormatter;

/**
 *  通过时间戳得出显示时间（NSCalendar方式）
 *
 *  @param timestamp 时间戳
 *  @return 例如：2017年5月14日
 */
+ (NSString *)wb_getDateStringWithTimestamp:(NSTimeInterval)timestamp;

/**
 *  将云客盟格式时间转换成时间字符串
 *
 *  @param dateString 时间字符串
 *  @return yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)wb_dateStringFromYKMDateString:(NSString *)dateString;
/**
 *  时间转换字符串
 *
 *  @param date 时间
 *  @param format 格式
 *  @return 时间字符串
 */
+ (NSString *)wb_dateStringFromDate:(NSDate *)date
                             format:(NSString *)format;
/**
 *  时间转换字符串
 *
 *  @param date 时间
 *  @return yyyy-MM-dd
 */
+ (NSString *)wb_dateStringFromDate:(NSDate *)date;
/**
 *  时间转换字符串
 *
 *  @param date 时间
 *  @return yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)wb_hourDateStringFromDate:(NSDate *)date;
#pragma mark -- Date

/**
 *  从时间字符串得到时间
 *
 *  @param dateString 时间字符串
 *  @param format 格式
 *  @return NSDate
 */
+ (NSDate *)wb_dateFromString:(NSString *)dateString
                   withFormat:(NSString *)format;

/**
 *  从时间字符串的得到时间
 *
 *  @param dateString 时间字符串
 *  @return NSDate (@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSDate *)wb_dateFromString:(NSString *)dateString;

/**
 *  将时间字符串转换为云客盟格式时间
 *
 *  @param dateString 时间字符串
 *  @return yyyyMMddHHmmss
 */
+ (NSDate *)wb_dateFromYKMString:(NSString *)dateString;

#pragma mark -- Timestamp
/**
 *  将字符串转化成离1970的毫秒数
 *
 *  @param dateString 时间字符串
 *  @return 时间戳
 */
+ (NSTimeInterval)wb_timeIntervalSince1970FromString:(NSString *)dateString;
/**
 *  当前时间转换为时间戳字符串
 *
 *  @return 时间戳字符串
 */
+ (NSString *)wb_toTimeStamp;

/**
 *  通过时间戳获取年龄大小
 *
 *  @param timestamp 生日时间戳
 *  @return 年龄字符串
 */
+ (NSInteger)wb_getAgeByTimestamp:(NSTimeInterval)timestamp;

@end
