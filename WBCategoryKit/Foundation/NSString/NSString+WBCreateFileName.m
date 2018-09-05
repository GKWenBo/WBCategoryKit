//
//  NSString+WBCreateFileName.m
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "NSString+WBCreateFileName.h"
#import "NSString+WBDeviceInfo.h"

@implementation NSString (WBCreateFileName)

- (NSString *)wb_createFileName {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags  = NSCalendarUnitYear|
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    
    NSDateComponents* dayComponents = [calendar components:(unitFlags) fromDate:date];
    NSUInteger year = [dayComponents year];
    NSUInteger month =  [dayComponents month];
    NSUInteger day =  [dayComponents day];
    NSInteger hour =  [dayComponents hour];
    NSInteger minute =  [dayComponents minute];
    double second = [dayComponents second];
    
    NSString *strMonth;
    NSString *strDay;
    NSString *strHour;
    NSString *strMinute;
    NSString *strSecond;
    if (month < 10) {
        strMonth = [NSString stringWithFormat:@"0%lu",(unsigned long)month];
    }
    else {
        strMonth = [NSString stringWithFormat:@"%lu",(unsigned long)month];
    }
    //NSLog(@"%@",strMonth.description);
    if (day < 10) {
        strDay = [NSString stringWithFormat:@"0%lu",(unsigned long)day];
    }
    else {
        strDay = [NSString stringWithFormat:@"%lu",(unsigned long)day];
    }
    
    if (hour < 10) {
        strHour = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    else {
        strHour = [NSString stringWithFormat:@"%ld",(long)hour];
    }
    
    if (minute < 10) {
        strMinute = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
    else {
        strMinute = [NSString stringWithFormat:@"%ld",(long)minute];
    }
    
    if (second < 10) {
        strSecond = [NSString stringWithFormat:@"0%0.f",second];
    }
    else {
        strSecond = [NSString stringWithFormat:@"%0.f",second];
    }
    
    NSString *str = [NSString stringWithFormat:@"%ld%@%@%@%@%@%@",
                     (unsigned long)year,strMonth,strDay,strHour,strMinute,strSecond,[NSString wb_stringWithUUID]];
    return str;
}

@end
