//
//  NSDate+WB_Time.m
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "NSDate+WBAddtional.h"
#import "WBDateFormatterPool.h"

@implementation NSDate (WBAddtional)

#pragma mark -- DateString
+ (NSString *)wb_currentDateWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:format];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)wb_getStringWithTimestamp:(NSTimeInterval)timestamp
                              formatter:(NSString*)formatter {
    if ([NSString stringWithFormat:@"%@", @(timestamp)].length == 13) {
        timestamp /= 1000.0f;
    }
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:formatter];
    [dateFormatter setDateFormat:formatter];
    NSString *strDate = [dateFormatter stringFromDate:timestampDate];
    return strDate;
}

+ (NSString *)wb_getStringByTimestamp:(NSTimeInterval)timeStamp
                               format:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *formatter = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:format
                                                                                localeIdentifier:@"en_US"
                                                                                    timeZoneName:nil];
    NSString *s = [formatter stringFromDate:date];
    return s;
}

+ (NSString *)wb_timestampToTimeStrWithTimestampStr:(NSString *)timestampStr
                                      dateFormatter:(NSString *)dateFormatter {
    NSTimeInterval time = [timestampStr doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *format = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:dateFormatter
                                                                             localeIdentifier:nil
                                                                                 timeZoneName:@"Asia/Beijing"];
    NSString *currentDateStr = [format stringFromDate: detaildate];
    return currentDateStr;
}

+ (NSString *)wb_dateStringFromYKMDateString:(NSString *)dateString {
    NSDate * date = [self wb_dateFromYKMString:dateString];
    NSDateFormatter *dateFormatter = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:kWBCustomDateFormat
                                                                                    localeIdentifier:nil
                                                                                        timeZoneName:nil];
    NSString *strDate = [dateFormatter stringFromDate: date];
    return strDate;
}

+ (NSString *)wb_dateStringFromDate:(NSDate *)date
                             format:(NSString *)format {
    NSDateFormatter * dateFormatter = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:format
                                                                                     localeIdentifier:nil
                                                                                         timeZoneName:nil];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)wb_dateStringFromDate:(NSDate *)date {
    return [self wb_dateStringFromDate:date
                                format:kWBDayFormatLine];
}

+ (NSString *)wb_hourDateStringFromDate:(NSDate *)date {
    return [self wb_dateStringFromDate:date
                                format:kWBCustomDateFormat];
}

+ (NSString *)wb_getDateStringWithTimestamp:(NSTimeInterval)timestamp {
    NSDate *confromTimesp    = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
    NSCalendar *calendar     = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents*referenceComponents=[calendar components:unitFlags fromDate:confromTimesp];
    NSInteger referenceYear  = referenceComponents.year;
    NSInteger referenceMonth = referenceComponents.month;
    NSInteger referenceDay   = referenceComponents.day;
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)referenceYear,(long)referenceMonth,(long)referenceDay];
}

#pragma mark -- Date
+ (NSDate *)wb_dateFromString:(NSString *)dateString
                   withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:format
                                                                                     localeIdentifier:nil
                                                                                         timeZoneName:nil];
    NSDate *date = [inputFormatter dateFromString:dateString];
    return date;
}

+ (NSDate *)wb_dateFromString:(NSString *)dateString {
    return [self wb_dateFromString:dateString
                        withFormat:kWBCustomDateFormat];
}

+ (NSDate *)wb_dateFromYKMString:(NSString *)dateString {
    return [self wb_dateFromString:dateString
                        withFormat:kWBYkmDateFormat];
}

#pragma mark -- Timestamp
+ (NSTimeInterval)wb_timeIntervalSince1970FromString:(NSString *)dateString {
    NSDate * date = [self wb_dateFromString:dateString
                                 withFormat:kWBCustomDateFormat];
    if (date) {
        NSTimeInterval time = [date timeIntervalSince1970] * 1000;
        return time;
    }
    return 0;
}

+ (NSString *)wb_toTimeStamp {
    return [NSString stringWithFormat:@"%.0lf", [[NSDate date] timeIntervalSince1970]];
}

@end
