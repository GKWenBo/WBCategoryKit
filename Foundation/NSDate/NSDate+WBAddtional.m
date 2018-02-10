//
//  NSDate+WB_Time.m
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "NSDate+WBAddtional.h"

@implementation NSDate (WBAddtional)

#pragma mark -- DateString
#pragma mark
+ (NSString *)wb_currentDateWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}
+ (NSString *)wb_getStringWithTimestamp:(NSTimeInterval)timestamp formatter:(NSString*)formatter {
    if ([NSString stringWithFormat:@"%@", @(timestamp)].length == 13) {
        timestamp /= 1000.0f;
    }
    NSDate*timestampDate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *strDate = [dateFormatter stringFromDate:timestampDate];
    return strDate;
}
+ (NSString *)wb_getStringByTimestamp:(NSTimeInterval)timeStamp format:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    //中文:zh_CN  英文:en_US 日文:ja_JP
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ;
    //formatter.timeZone = [NSTimeZone localTimeZone];//[NSTimeZone timeZoneWithAbbreviation:@"EST"];//
    NSString *s = [formatter stringFromDate:date];
    return s;
}
+ (NSString *)wb_timestampToTimeStrWithTimestampStr:(NSString *)timestampStr
                                      dateFormatter:(NSString *)dateFormatter {
    NSTimeInterval time=[timestampStr doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //设置时区（北京东八区）
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [format setTimeZone:timeZone];
    //设定时间格式,这里可以设置成自己需要的格式
    [format setDateFormat:dateFormatter];
    NSString *currentDateStr = [format stringFromDate: detaildate];
    return currentDateStr;

}

+ (NSString *)wb_dateStringFromYKMDateString:(NSString *)dateString {
    NSDate * date = [self wb_dateFromYKMString:dateString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:CustomDateFormat];
    NSString *strDate = [dateFormatter stringFromDate: date];
    return strDate;
}
+ (NSString *)wb_dateStringFromDate:(NSDate *)date
                             format:(NSString *)format {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)wb_dateStringFromDate:(NSDate *)date {
    return [self wb_dateStringFromDate:date format:DayFormatLine];
}
+ (NSString *)wb_hourDateStringFromDate:(NSDate *)date {
    return [self wb_dateStringFromDate:date format:CustomDateFormat];
}
+ (NSString *)wb_getDateStringWithTimestamp:(NSTimeInterval)timestamp {
    NSDate *confromTimesp    = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSCalendar *calendar     = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents*referenceComponents=[calendar components:unitFlags fromDate:confromTimesp];
    NSInteger referenceYear  =referenceComponents.year;
    NSInteger referenceMonth =referenceComponents.month;
    NSInteger referenceDay   =referenceComponents.day;
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",referenceYear,(long)referenceMonth,(long)referenceDay];
}

#pragma mark -- Date
#pragma mark
+ (NSDate *)wb_dateFromString:(NSString *)dateString withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:dateString];
    return date;
}
+ (NSDate *)wb_dateFromString:(NSString *)dateString {
    return [self wb_dateFromString:dateString withFormat:CustomDateFormat];
}
+ (NSDate *)wb_dateFromYKMString:(NSString *)dateString {
    return [self wb_dateFromString:dateString withFormat:YkmDateFormat];
}
#pragma mark -- Timestamp
#pragma mark
+ (NSTimeInterval)wb_timeIntervalSince1970FromString:(NSString *)dateString {
    NSDate * date = [self wb_dateFromString:dateString withFormat:CustomDateFormat];
    if (date) {
        NSTimeInterval time = [date timeIntervalSince1970]*1000;
        return time;
    }
    return 0;
}
+ (NSString *)wb_toTimeStamp {
    
    return [NSString stringWithFormat:@"%.0lf", [[NSDate date] timeIntervalSince1970]];
}

@end
