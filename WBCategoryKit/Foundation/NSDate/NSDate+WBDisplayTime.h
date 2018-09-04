//
//  NSDate+WB_DisplayTime.h
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WBDisplayTime)

/**
 通过时间戳计算时间差

 @param compareDate 时间戳
 @return 刚刚、几分钟前、.....
 */
+ (NSString *)wb_compareCurrentTime:(NSTimeInterval)compareDate;

/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *  @param currentTime 最近日期(需要和格式对应)
 *  @param format2     最近日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)wb_timeIntervalFromLastTime:(NSString *)lastTime
                           lastTimeFormat:(NSString *)format1
                            ToCurrentTime:(NSString *)currentTime
                        currentTimeFormat:(NSString *)format2;

/**
 *  通过时间字符串计算时间差
 *
 *  @param theDate 时间字符串
 *  @return 时间差
 */
+ (NSString *)wb_intervalSinceNow:(NSString *) theDate;
+ (NSString *)wb_prettyDateWithReference:(NSString *)theDate;

/**
 *  动态页面时间显示样式
 *
 */
+ (NSString *)wb_getDynamicDateStringByTimestampStyleOne:(NSTimeInterval)timestamp;
+ (NSString *)wb_getDynamicDateStringByTimestampStyleTwo:(NSTimeInterval)timestamp;


/**
 通过时间字符串计算时间差

 @param timeString 时间字符串，example：2018-06-19 16:24:10
 @return 几年/月/周...前.
 */
+ (NSString *)compareCurrentTimeWithTimeString:(NSString *)timeString;

@end
