//
//  NSDate+WB_DisplayTime.m
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "NSDate+WBDisplayTime.h"
#import "NSDate+WBAddtional.h"
#import "WBDateFormatterPool.h"

@implementation NSDate (WBDisplayTime)

+ (NSString *)wb_compareCurrentTime:(NSTimeInterval) compareDate {
    NSDate *confromTimesp        = [NSDate dateWithTimeIntervalSince1970:compareDate / 1000];
    NSTimeInterval  timeInterval = [confromTimesp timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    NSCalendar *calendar     = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *referenceComponents = [calendar components:unitFlags fromDate:confromTimesp];
    NSInteger referenceHour  =referenceComponents.hour;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp= timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = timeInterval/3600) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if ((temp = timeInterval/3600/24)==1)
    {
        result = [NSString stringWithFormat:@"昨天%ld时",(long)referenceHour];
    }
    else if ((temp = timeInterval/3600/24)==2)
    {
        result = [NSString stringWithFormat:@"前天%ld时",(long)referenceHour];
    }
    
    else if((temp = timeInterval/3600/24) <31){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = timeInterval/3600/24/30) <12){
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}

+ (NSString *)wb_timeIntervalFromLastTime:(NSString *)lastTime
                           lastTimeFormat:(NSString *)format1
                            ToCurrentTime:(NSString *)currentTime
                        currentTimeFormat:(NSString *)format2 {
    //上次时间
    NSDateFormatter *dateFormatter1 = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:format1
                                                                                     localeIdentifier:nil
                                                                                         timeZoneName:nil];
    NSDate *lastDate = [dateFormatter1 dateFromString:lastTime];
    //当前时间
    NSDateFormatter *dateFormatter2 = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:format2
                                                                                     localeIdentifier:nil
                                                                                         timeZoneName:nil];
    NSDate *currentDate = [dateFormatter2 dateFromString:currentTime];
    return [self timeIntervalFromLastTime:lastDate ToCurrentTime:currentDate];
}

+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime
                         ToCurrentTime:(NSDate *)currentTime{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    //上次时间
    NSDate *lastDate = [lastTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:lastTime]];
    //当前时间
    NSDate *currentDate = [currentTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:currentTime]];
    //时间间隔
    NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];
    
    //秒、分、小时、天、月、年
    NSInteger minutes = intevalTime / 60;
    NSInteger hours = intevalTime / 60 / 60;
    NSInteger day = intevalTime / 60 / 60 / 24;
    NSInteger month = intevalTime / 60 / 60 / 24 / 30;
    NSInteger yers = intevalTime / 60 / 60 / 24 / 365;
    
    if (minutes <= 10) {
        return  @"刚刚";
    }else if (minutes < 60){
        return [NSString stringWithFormat: @"%ld分钟前",(long)minutes];
    }else if (hours < 24){
        return [NSString stringWithFormat: @"%ld小时前",(long)hours];
    }else if (day < 30){
        return [NSString stringWithFormat: @"%ld天前",(long)day];
    }else if (month < 12){
        NSDateFormatter * df = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"M月d日"
                                                                              localeIdentifier:nil
                                                                                  timeZoneName:nil];
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }else if (yers >= 1){
        NSDateFormatter * df = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyy年M月d日"
                                                                              localeIdentifier:nil
                                                                                  timeZoneName:nil];
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }
    return @"";
}

+ (NSString *)wb_intervalSinceNow:(NSString *)theDate {
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[theDate longLongValue]];
    NSTimeInterval late = [d timeIntervalSince1970];
    NSDate* dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970];
    NSString *timeString = @"";
    NSTimeInterval cha = now - late;
    if (cha / 3600 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        if ([timeString intValue] < 2)
        {
            timeString = @"刚刚";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }
    if (cha/3600 > 1 && cha / 86400 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400 > 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 86400];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
    }
    return timeString;
}

+ (NSString *)wb_prettyDateWithReference:(NSString *)theDate {
    NSDate *reference = [NSDate dateWithTimeIntervalSince1970:[theDate longLongValue]];
    NSString *suffix = @"前";
    NSDate *nowUTC = [NSDate date];
    float different = [reference timeIntervalSinceDate:nowUTC];
    if (different < 0) {
        different = -different;
        //        suffix = @"from now";
    }
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    int days   = (int)dayDifferent;
    int weeks  = (int)ceil(dayDifferent / 7);
    int months = (int)ceil(dayDifferent / 30);
    int years  = (int)ceil(dayDifferent / 365);
    
    // It belongs to today
    if (dayDifferent <= 0) {
        // lower than 60 seconds
        if (different < 60) {
            return @"刚刚";
        }
        
        // lower than 120 seconds => one minute and lower than 60 seconds
        if (different < 120) {
            return [NSString stringWithFormat:@"1 分钟%@", suffix];
        }
        
        // lower than 60 minutes
        if (different < 60 * 60) {
            return [NSString stringWithFormat:@"%d 分钟%@", (int)floor(different / 60), suffix];
        }
        
        // lower than 60 * 2 minutes => one hour and lower than 60 minutes
        if (different < 7200) {
            return [NSString stringWithFormat:@"1 小时%@", suffix];
        }
        
        // lower than one day
        if (different < 86400) {
            return [NSString stringWithFormat:@"%d 小时%@", (int)floor(different / 3600), suffix];
        }
    }
    // lower than one week
    else if (days < 7) {
        return [NSString stringWithFormat:@"%d 天%@", days,  suffix];
    }
    // lager than one week but lower than a month
    else if (weeks < 4) {
        return [NSString stringWithFormat:@"%d 周%@", weeks, suffix];
    }
    // lager than a month and lower than a year
    else if (months < 12) {
        return [NSString stringWithFormat:@"%d 月%@", months,  suffix];
    }
    // lager than a year
    else {
        return [NSString stringWithFormat:@"%d 年%@", years,  suffix];
    }
    
    return self.description;
}

+ (NSString *)wb_getDynamicDateStringByTimestampStyleOne:(NSTimeInterval)timestamp {
    NSDateFormatter *format = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"
                                                                             localeIdentifier:nil
                                                                                 timeZoneName:nil];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *dateStr = [format stringFromDate:d];// 2012-05-17 11:23:23
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    switch ((int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(24*3600)) -
            (int)(([d timeIntervalSince1970] + timezoneFix)/(24*3600)))
    {
        case 0:
            dateStr = [NSString stringWithFormat:@"%@", [[dateStr substringFromIndex:11]substringToIndex:5]];
            break;
        case 1:
            dateStr = [NSString stringWithFormat:@"昨天 %@", [[dateStr substringFromIndex:11]substringToIndex:5]];
            break;
            
        default:
            dateStr = [dateStr substringWithRange:NSMakeRange(5, 6)];
            break;
    }
    return dateStr;
}

+ (NSString *)wb_getDynamicDateStringByTimestampStyleTwo:(NSTimeInterval)timestamp {
    NSDateFormatter *format = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss HH:mm:ss"
                                                                             localeIdentifier:nil
                                                                                 timeZoneName:nil];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSString *dateStr = [format stringFromDate:d];// 2012-05-17 11:23:23
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    switch ((int)(([[NSDate date] timeIntervalSince1970] + timezoneFix) / (24 * 3600)) -
            (int)(([d timeIntervalSince1970] + timezoneFix) / (24 * 3600)))
    {
        case 0:
            dateStr = [NSString stringWithFormat:@"%@", [[dateStr substringFromIndex:11] substringToIndex:5]];
            break;
        case 1:
            dateStr = [NSString stringWithFormat:@"昨天 %@", [[dateStr substringFromIndex:11] substringToIndex:5]];
            break;
            
        default:
            dateStr = [dateStr substringWithRange:NSMakeRange(5, 11)];
            break;
    }
    return dateStr;
}

+ (NSString *)compareCurrentTimeWithTimeString:(NSString *)timeString {
    if (!timeString) return nil;
    NSDateFormatter *formatter = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [NSDate date];
    NSDate *compareDate = [formatter dateFromString:timeString];
    /** < 时间差转换成秒 > */
    long delta = (long)[nowDate timeIntervalSinceDate:compareDate];
    if (delta <= 0 )return timeString;
    if(delta / (60 * 60 * 24 * 365) > 0) return [NSString stringWithFormat:@"%ld年前", delta / (60 * 60 * 24 * 365)];
    if (delta / (60 * 60 * 24 * 30) > 0) return [NSString stringWithFormat:@"%ld月前", delta / (60 * 60 * 24 * 30)];
    if (delta / (60 * 60 * 24 * 7) > 0) return [NSString stringWithFormat:@"%ld周前", delta / (60 * 60 * 24 * 7)];
    if (delta / (60 * 60 * 24) > 0) return [NSString stringWithFormat:@"%ld天前", delta / (60 * 60 * 24)];
    if (delta / (60 * 60) > 0) return [NSString stringWithFormat:@"%ld小时前", delta / (60 * 60)];
    if (delta / (60) > 0) return [NSString stringWithFormat:@"%ld分钟前", delta / (60)];
    return @"刚刚";
}

@end
