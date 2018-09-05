//
//  WBDateFormatterPool.h
//  WBDateFormatterPool
//
//  Created by wenbo on 2018/5/16.
//  Copyright © 2018年 wenbo. All rights reserved.
//

/** <
    NSDateFormatter缓存工具，避免多次创建消耗性能
 >  */

#import <Foundation/Foundation.h>

@interface WBDateFormatterPool : NSObject


+ (instancetype)new NS_UNAVAILABLE;

/**
 单例管理

 @return instance WBDateFormatterPool.
 */
+ (instancetype)shareInstance;

/**
 Get date formatter by format string, the default locale is [NSLocale currentLocale]

 @param format date format string, example: @"yyyy-MM-dd hh:mm:ss"
 @return NSDateFormatter
 */
- (NSDateFormatter *)wb_dateFormatterWithFormat:(NSString *)format;

/**
 Get date formatter by date style, time style, the default locale is [NSLocale currentLocale].
 
 typedef NS_ENUM(NSUInteger, NSDateFormatterStyle) {    // date and time format styles
 NSDateFormatterNoStyle = kCFDateFormatterNoStyle,
 NSDateFormatterShortStyle = kCFDateFormatterShortStyle,
 NSDateFormatterMediumStyle = kCFDateFormatterMediumStyle,
 NSDateFormatterLongStyle = kCFDateFormatterLongStyle,
 NSDateFormatterFullStyle = kCFDateFormatterFullStyle
 };

 @param dateStyle date style.
 @param timeStyle time style.
 @return NSDateFormatter.
 */
- (NSDateFormatter *)wb_dateFormatterWithFormat:(NSDateFormatterStyle)dateStyle
                                      timeStyle:(NSDateFormatterStyle)timeStyle;

/**
 Get date formatter by format string, localeIdentifier, timeZoneName.

 @param format date format.
 @param identifier locale identifier.
 @param timeZoneName timeZone name string.
 @return NSDateFormatter.
 */
- (NSDateFormatter *)wb_dateFormatterWithFormat:(NSString *)format
                               localeIdentifier:(NSString *)identifier
                                   timeZoneName:(NSString *)timeZoneName;

/**
 Get date formatter by date style, time style, localeIdentifier, timeZoneName.

 @param dateStyle date style.
 @param timeStyle time style.
 @param identifier locale identifier.
 @param timeZoneName timeZone name string.
 @return NSDateFormatter.
 */
- (NSDateFormatter *)wb_dateFormatterWithFormat:(NSDateFormatterStyle)dateStyle
                                      timeStyle:(NSDateFormatterStyle)timeStyle
                               localeIdentifier:(NSString *)identifier
                                   timeZoneName:(NSString *)timeZoneName;

@end
