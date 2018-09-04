//
//  NSDate+WBTimePredicate.h
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WBTimePredicate)

/**
 *  农历时间
 *
 *  @param date 时间
 *  @return 例如：正月 初一
 */
+ (NSString *)wb_getChineseCalendarWithDate:(NSDate *)date;

/**
 *  获取时间
 *
 *  @param date 时间
 *  @return yyyy-MM-dd
 */
+ (NSDate *)wb_dateWithYMD:(NSDate *)date;

/**
 *  星期几
 *
 *  @param inputDate 时间
 *  @return 星期几
 */
+ (NSString *)wb_weekdayStringFromDate:(NSDate *)inputDate;
+ (NSString *)wb_getWeekdayByTimeStamp:(NSString *)timeStamp;

/**
 *  获取明天日期
 *
 *  @return 明天日期
 */
+ (NSDate *)wb_dateTomorrow;

/**
 *  获取昨天日期
 *
 *  @return 昨天日期
 */
+ (NSDate *)wb_dateYesterday;

/**
 *  获取指定天数后的日期
 *
 *  @param days 天数
 *  @return NSDate
 */
+ (NSDate *)wb_dateWithDaysFromNow:(NSUInteger)days;

/**
 *  获取指定天数前的日期
 *
 *  @param days 天数
 *  @return NSDate
 */

+ (NSDate *)wb_dateWithDaysBeforeNow:(NSInteger)days;

/**
 *  获取指定小时数后的日期
 *
 *  @param dHours 小时数
 *  @return NSDate类型
 */
+ (NSDate *)wb_dateWithHoursFromNow:(NSUInteger)dHours;

/**
 *  获取指定小时数前的日期
 *
 *  @param dHours 小时数
 *  @return NSDate类型
 */
+ (NSDate *)wb_dateWithHoursBeforeNow:(NSInteger)dHours;

/**
 *  获取指定分钟后的日期
 *  @param dMinutes 分钟
 *  @return NSDate类型
 */
+ (NSDate *)wb_dateWithMinutesFromNow:(NSUInteger)dMinutes;

/**
 *  获取指定分钟前的日期
 *  @param dMinutes 分钟
 *  @return NSDate类型
 */
+ (NSDate *)wb_dateWithMinutesBeformNow:(NSInteger)dMinutes;

/**
 *  当前日期与指定日期比较是否相等
 *  @param aDate 日期
 *  @return 是否相等
 */
+ (BOOL)wb_isEqualtoDatelgnoringTime:(NSDate *)aDate;

/**
 *  是不是今天
 *  @param aDate 日期
 *  @return 是否相等
 */
+ (BOOL)wb_isToday:(NSDate *)aDate;
+ (BOOL)wb_isTodayByTimestamp:(NSTimeInterval)timestamp;

/**
 *  是不是明天
 *  @param aDate 日期
 *  @return 是否相等
 */
+ (BOOL)wb_isTomorrow:(NSDate *)aDate;

/**
 *  是不是昨天
 *  @param aDate 日期
 *  @return 是否相等
 */
+ (BOOL)wb_isYesterday:(NSDate *)aDate;
+ (BOOL)wb_isYesterdayByTimestamp:(NSTimeInterval)timestamp;

/**
 *  是不是同一周
 *  @param aDate 日期
 *  @return 是否相等
 */
+ (BOOL)wb_isSameWeekAsDate:(NSDate *)aDate;

/**
 *  是不是本周
 *  @param aDate 日期
 *  @return NSDate类型
 */
+ (BOOL)wb_isThisWeek:(NSDate *)aDate;

/**
 *  是不是下一周
 *  @param aDate 日期
 *  @return 是否相等
 */
+ (BOOL)wb_isNextWeek:(NSDate *)aDate;

/**
 *  是不是上一周
 *  @param aDate 日期
 *  @return 是否相等
 */
+ (BOOL)wb_isLastWeek:(NSDate *)aDate;

/**
 *  是不是同一年
 *  @param aDate 日期
 *  @return NSDate类型
 */
+ (BOOL)wb_isSameYearAsDate:(NSDate *)aDate
                 andSecDate:(NSDate *) bDate;

/**
 *  是不是本年
 *  @param aDate 日期
 *  @return 是否相等
 */
+ (BOOL)wb_isThisYear:(NSDate *)aDate;
+ (BOOL)wb_isThisYearByTimestamp:(NSTimeInterval)timestamp;

/**
 *  是不是下一年
 *  @param aDate 日期
 *  @return NSDate类型
 */
+ (BOOL)wb_isNextYear:(NSDate *)aDate;

/**
 *  是不是上一年
 *  @param aDate 日期
 *  @return NSDate类型
 */
+ (BOOL)wb_isLastYear:(NSDate *)aDate;

/**
 *  是不是比dDate早
 *  @param aDate 指定日期
 *  @return NSDate类型
 */
+ (BOOL)wb_isEarlierThanDate:(NSDate *)aDate;

/**
 *  是不是比aData晚
 *  @param aDate 指定日期
 *  @return NSDate类型
 */
+ (BOOL)wb_isLaterThanDate:(NSDate *)aDate;

/**
 *  某一日期指定天数后的日期
 *
 *  @param days 天数
 *  @param beginDateStr 开始时间字符串  格式@“yyyy-MM-dd”
 *  @return 指定天数后的日期
 */
+ (NSDate *)wb_computeDateWithDays:(NSInteger)days
                      beginDateStr:(NSString *)beginDateStr;



@end
