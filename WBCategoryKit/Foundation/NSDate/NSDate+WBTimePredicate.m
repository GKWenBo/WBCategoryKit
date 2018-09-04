//
//  NSDate+WB_TimePredicate.m
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "NSDate+WBTimePredicate.h"
#import "WBDateFormatterPool.h"

@implementation NSDate (WBTimePredicate)
+ (NSString *)wb_getChineseCalendarWithDate:(NSDate *)date {
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths = [NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays = [NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags
                                                     fromDate:date];
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    return chineseCal_str;
}

+ (NSDate *)wb_dateWithYMD:(NSDate *)date {
    NSDateFormatter *fmt = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyy-MM-dd"
                                                                          localeIdentifier:nil
                                                                              timeZoneName:nil];
    NSString *selfStr = [fmt stringFromDate:date];
    return [fmt dateFromString:selfStr];
}

+ (NSString *)wb_weekdayStringFromDate:(NSDate *)inputDate{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit
                                                  fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)wb_getWeekdayByTimeStamp:(NSString *)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    /**  < 消除警告宏 >  */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
#pragma clang diagnostic pop
    comps = [calendar components:unitFlags fromDate:date];
    return [self getWeekdayWithNumber:[comps weekday]];
}

//1代表星期日、如此类推
+ (NSString *)getWeekdayWithNumber:(NSInteger)number {
    switch (number) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            return @"";
            break;
    }
}

+ (NSDate *)wb_dateTomorrow {
    return [[NSDate date] initWithTimeIntervalSinceNow:24 * 60 * 60 ];
}

+ (NSDate *)wb_dateYesterday {
    
    return [[NSDate date] initWithTimeIntervalSinceNow: -24 * 60 * 60];
}

+ (NSDate *)wb_dateWithDaysFromNow:(NSUInteger)days {
    return [[NSDate date] initWithTimeIntervalSinceNow:days * 24 * 60 * 60];
}

+ (NSDate *)wb_dateWithDaysBeforeNow:(NSInteger)days {
    return [[NSDate date] initWithTimeIntervalSinceNow:((-24) * 60 * 60 * days)];
}

+ (NSDate *)wb_dateWithHoursFromNow:(NSUInteger)dHours {
    return [[NSDate date] initWithTimeIntervalSinceNow:dHours * 60 * 60];
}

+ (NSDate *)wb_dateWithHoursBeforeNow:(NSInteger)dHours {
    return [[NSDate date] initWithTimeIntervalSinceNow:dHours * 60 * 60 * (-1)];
}

+ (NSDate *)wb_dateWithMinutesFromNow:(NSUInteger)dMinutes {
    return [[NSDate date] initWithTimeIntervalSinceNow:dMinutes * 60];
}

+ (NSDate *)wb_dateWithMinutesBeformNow:(NSInteger)dMinutes {
    return [[NSDate date] initWithTimeIntervalSinceNow:dMinutes * 60 * (-1)];
}

+ (BOOL)wb_isEqualtoDatelgnoringTime:(NSDate *)aDate {
    return [[NSDate date] isEqualToDate:aDate];
}

+ (BOOL)wb_isToday:(NSDate *)aDate {
    NSCalendar *cld = [NSCalendar currentCalendar];
    return [cld isDateInToday:aDate];
}

+ (BOOL)wb_isTodayByTimestamp:(NSTimeInterval)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

+ (BOOL)wb_isTomorrow:(NSDate *)aDate {
    NSCalendar *cld = [NSCalendar currentCalendar];
    return [cld isDateInTomorrow:aDate];
}

+ (BOOL)wb_isYesterday:(NSDate *)aDate {
    NSCalendar *cld = [NSCalendar currentCalendar];
    return [cld isDateInYesterday:aDate];
}

+ (BOOL)wb_isYesterdayByTimestamp:(NSTimeInterval)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDate *nowDate = [self wb_dateWithYMD:[NSDate date]];
    // 2014-04-30
    NSDate *selfDate = [self wb_dateWithYMD:date];
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

+ (BOOL)wb_isSameWeekAsDate:(NSDate *)aDate {
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    BOOL success = [cal rangeOfUnit:NSCalendarUnitWeekday startDate:&start interval:&extends forDate:today];
    
    if (!success) {
        return false;
    }
    NSTimeInterval dateInSecs = [aDate timeIntervalSinceReferenceDate];
    NSTimeInterval dateStartInSecs = [start timeIntervalSinceReferenceDate];
    if (dateInSecs > dateStartInSecs && dateInSecs < (dateStartInSecs - extends)) {
        return true;
    }else {
        return false;
    }
}

+ (BOOL)wb_isThisWeek:(NSDate *)aDate {
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    // 根据参数提供的时间点，返回所在日历单位的开始时间。如果startDate和interval均可以计算，则返回YES；否则返回NO
    // extends获取的是日历单位所对应的秒数
    BOOL success = [cal rangeOfUnit:NSCalendarUnitWeekday startDate:&start interval:&extends forDate:today];
    if (!success) {
        return false;
    }
    NSTimeInterval dateInSecs = [aDate timeIntervalSinceReferenceDate];
    NSTimeInterval dateStartInSecs = [start timeIntervalSinceReferenceDate];
    if (dateInSecs > dateStartInSecs && dateInSecs < (dateStartInSecs - extends)) {
        return true;
    }else {
        return false;
    }
}

+ (BOOL)wb_isNextWeek:(NSDate *)aDate {
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    BOOL success = [cal rangeOfUnit:NSCalendarUnitWeekday startDate:&start interval:&extends forDate:today];
    if (!success) {
        return false;
    }
    NSTimeInterval dateInSecs = [aDate timeIntervalSinceReferenceDate];
    NSTimeInterval dateStartInSecs = [start timeIntervalSinceReferenceDate];
    if (dateInSecs > (dateStartInSecs - extends) && dateInSecs < (dateStartInSecs - 2 * extends)) {
        return true;
    }else {
        return false;
    }
}

+ (BOOL)wb_isLastWeek:(NSDate *)aDate {
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    BOOL success = [cal rangeOfUnit:NSCalendarUnitWeekday startDate:&start interval:&extends forDate:today];
    if (!success) {
        return false;
    }
    NSTimeInterval dateInSecs = [aDate timeIntervalSinceReferenceDate];
    NSTimeInterval dateStartInSecs = [start timeIntervalSinceReferenceDate];
    if (dateInSecs < dateStartInSecs && dateInSecs > (dateStartInSecs - extends)) {
        return true;
    }else {
        return false;
    }
}

+ (BOOL)wb_isSameYearAsDate:(NSDate *)aDate
                 andSecDate:(NSDate *)bDate {
    NSDateFormatter *ds = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyy"
                                                                         localeIdentifier:nil
                                                                             timeZoneName:nil];
    NSString *bDateStr = [ds stringFromDate:bDate];
    NSString *aDateStr = [ds stringFromDate:aDate];
    if ([aDateStr isEqual:bDateStr]) {
        return true;
    }else {
        return false;
    }
}

+ (BOOL)wb_isThisYear:(NSDate *)aDate {
    NSDateFormatter *ds = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyy"
                                                                         localeIdentifier:nil
                                                                             timeZoneName:nil];
    NSString *currentDateStr = [ds stringFromDate:[NSDate date]];
    NSString *compareDateStr = [ds stringFromDate:aDate];
    if ([currentDateStr isEqual:compareDateStr]) {
        return true;
    }else {
        return false;
    }
}

+ (BOOL)wb_isThisYearByTimestamp:(NSTimeInterval)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return nowCmps.year == selfCmps.year;
}

+ (BOOL)wb_isNextYear:(NSDate *)aDate {
    NSDateFormatter *ds = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyy"
                                                                         localeIdentifier:nil
                                                                             timeZoneName:nil];
    NSString *currentDateStr = [ds stringFromDate:[NSDate date]];
    NSString *compareDateStr = [ds stringFromDate:aDate];
    NSInteger currentDateInt = [currentDateStr integerValue];
    NSInteger compareDateInt = [compareDateStr integerValue];
    if (compareDateInt - currentDateInt == 1) {
        return true;
    }else {
        return false;
    }
}

+ (BOOL)wb_isLastYear:(NSDate *)aDate {
    NSDateFormatter *ds = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyy"
                                                                         localeIdentifier:nil
                                                                             timeZoneName:nil];
    NSString *currentDateStr = [ds stringFromDate:[NSDate date]];
    NSString *compareDateStr = [ds stringFromDate:aDate];
    NSInteger currentDateInt = [currentDateStr integerValue];
    NSInteger compareDateInt = [compareDateStr integerValue];
    if (currentDateInt - compareDateInt == 1) {
        return true;
    }else {
        return false;
    }
}

+ (BOOL)wb_isEarlierThanDate:(NSDate *)aDate {
    NSDate *date = [[NSDate alloc] init];
    if ([[date laterDate:aDate] isEqualToDate:aDate]) {
        return true;
    }else {
        return false;
    }
}

+ (BOOL)wb_isLaterThanDate:(NSDate *)aDate {
    NSDate *date = [[NSDate alloc] init];
    if ([[date earlierDate:aDate] isEqualToDate:aDate]) {
        return false;
    }else {
        return true;
    }
}

+ (NSDate *)wb_computeDateWithDays:(NSInteger)days
                      beginDateStr:(NSString *)beginDateStr;
{
    NSDateFormatter *dateFormatter = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyy-MM-dd"
                                                                                    localeIdentifier:nil
                                                                                        timeZoneName:nil];
    NSDate *myDate = [dateFormatter dateFromString:beginDateStr];
    NSDate *newDate = [myDate dateByAddingTimeInterval:24 * 60 * 60 * days];
    return newDate;
}

@end
