//
//  WBDateFormatterPool.m
//  WBDateFormatterPool
//
//  Created by wenbo on 2018/5/16.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WBDateFormatterPool.h"

@interface WBDateFormatterPool ()

@property (nonatomic, strong) NSMutableDictionary *dateFormatterCache;

@end

/** < 信号量，保证NSDateFormatter线程安全 >  */
static dispatch_semaphore_t _cahcePoolLook;

@implementation WBDateFormatterPool

+ (instancetype)shareInstance {
    static WBDateFormatterPool *instache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instache = [[self alloc]init];
        _cahcePoolLook = dispatch_semaphore_create(1);
    });
    return instache;
}

#pragma mark < Public Method >
- (NSDateFormatter *)wb_dateFormatterWithFormat:(NSString *)format {
    return [self wb_dateFormatterWithFormat:format localeIdentifier:[NSLocale currentLocale].localeIdentifier timeZoneName:nil];
}

- (NSDateFormatter *)wb_dateFormatterWithFormat:(NSDateFormatterStyle)dateStyle
                                      timeStyle:(NSDateFormatterStyle)timeStyle {
    return [self wb_dateFormatterWithFormat:dateStyle timeStyle:timeStyle localeIdentifier:[NSLocale currentLocale].localeIdentifier timeZoneName:nil];
}

#pragma mark < Basic Method >
- (NSDateFormatter *)wb_dateFormatterWithFormat:(NSString *)format
                               localeIdentifier:(NSString *)identifier
                                   timeZoneName:(NSString *)timeZoneName {
    if (![format isKindOfClass:[NSString class]] || format.length == 0) return nil;
    NSString *key = [self wb_getCacheKeyWithFormat:format
                                  localeIdentifier:identifier
                                      timeZoneName:timeZoneName];
    NSDateFormatter *formatter = [self.dateFormatterCache objectForKey:key];
    if (formatter) return formatter;
    
    formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = format;
    if (identifier) formatter.locale = [NSLocale localeWithLocaleIdentifier:identifier];
    if (timeZoneName) formatter.timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    [self wb_cacheDateFormatter:formatter
                         forKey:key];
    return formatter;
}

- (NSDateFormatter *)wb_dateFormatterWithFormat:(NSDateFormatterStyle)dateStyle
                                      timeStyle:(NSDateFormatterStyle)timeStyle
                               localeIdentifier:(NSString *)identifier
                                   timeZoneName:(NSString *)timeZoneName {

    NSString *key = [self wb_getCacheKeyWithDateStyle:dateStyle
                                            timeStyle:timeStyle
                                     localeIdentifier:identifier
                                         timeZoneName:timeZoneName];
    NSLog(@"%@",key);
    NSDateFormatter *formatter = [self.dateFormatterCache objectForKey:key];
    if (formatter) return formatter;
    
    formatter = [[NSDateFormatter alloc]init];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    if (identifier) formatter.locale = [NSLocale localeWithLocaleIdentifier:identifier];
    if (timeZoneName) formatter.timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    [self.dateFormatterCache setObject:formatter
                                forKey:key];
    return formatter;
}

#pragma mark < getter >
- (NSString *)wb_getCacheKeyWithFormat:(NSString *)format
                      localeIdentifier:(NSString *)identifier
                          timeZoneName:(NSString *)timeZoneName {
    NSMutableString *key = [NSMutableString string];
    if (format) [key appendString:format];
    if (identifier) [key appendFormat:@"|%@",identifier];
    if (timeZoneName) [key appendFormat:@"|%@",timeZoneName];
    return key.copy;
}

- (NSString *)wb_getCacheKeyWithDateStyle:(NSDateFormatterStyle)dateStyle
                                timeStyle:(NSDateFormatterStyle)timeStyle
                         localeIdentifier:(NSString *)identifier
                             timeZoneName:(NSString *)timeZoneName {
    NSMutableString *key = [NSMutableString string];
    if (dateStyle) [key appendFormat:@"%lu",dateStyle];
    if (timeStyle) [key appendFormat:@"|%lu",timeStyle];
    if (identifier) [key appendFormat:@"|%@",identifier];
    if (timeZoneName) [key appendFormat:@"|%@",timeZoneName];
    return key.copy;
}

- (NSDateFormatter *)wb_getDateFormatterByKey:(NSString *)key {
    dispatch_semaphore_wait(_cahcePoolLook, DISPATCH_TIME_FOREVER);
    NSDateFormatter *dateFormatter = [self.dateFormatterCache objectForKey:key];
    dispatch_semaphore_signal(_cahcePoolLook);
    return dateFormatter;
}

- (void)wb_cacheDateFormatter:(NSDateFormatter *)dateFormatter
                       forKey:(NSString *)key {
    dispatch_semaphore_wait(_cahcePoolLook, DISPATCH_TIME_FOREVER);
    [self.dateFormatterCache setObject:dateFormatter forKey:key];
    dispatch_semaphore_signal(_cahcePoolLook);
}

- (NSMutableDictionary *)dateFormatterCache {
    if (!_dateFormatterCache) {
        _dateFormatterCache = [[NSMutableDictionary alloc]init];
    }
    return _dateFormatterCache;
}

@end
