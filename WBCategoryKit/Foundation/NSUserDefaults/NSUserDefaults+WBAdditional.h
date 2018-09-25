//
//  NSUserDefaults+WBAdditional.h
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (WBAdditional)

#pragma mark ------ < 第一次启动程序 > ------
/**
 Check app is need guide.

 @return YES/NO
 */
+ (BOOL)wb_isNeedGuide;

#pragma mark ------ < 判断 > ------
/**
 判断是否包含某个key

 @param key key
 @return YES/NO
 */
+ (BOOL)wb_checkHaveKey:(NSString *)key;

#pragma mark ------ < 存取 > ------
+ (id)wb_objectForKey:(NSString *)key;

+ (void)wb_saveObject:(id)object
               forKey:(NSString *)key;

+ (void)wb_saveIntegerValue:(NSInteger)integerValue
                     forKey:(NSString *)key;

+ (void)wb_saveFloatValue:(float)floatValue
                     forKey:(NSString *)key;

+ (void)wb_saveDoubleValue:(double)doubleValue
                     forKey:(NSString *)key;

+ (void)wb_saveBoolValue:(BOOL)boolValue
                  forKey:(NSString *)key;

+ (void)wb_saveLonglongValue:(int64_t)longlongValue
                      forKey:(NSString *)key;

+ (NSInteger)wb_integerValueForKey:(NSString *)key;
+ (BOOL)wb_boolValueForKey:(NSString *)key;
+ (float)wb_floatValueForKey:(NSString *)key;
+ (double)wb_doubleValueForKey:(NSString *)key;
+ (NSDictionary *)wb_dictionaryValueForKey:(NSString *)key;
+ (NSArray *)wb_arrayValueForKey:(NSString *)key;
+ (NSData *)wb_dataValueForKey:(NSString *)key;
+ (NSString *)wb_stringValueForKey:(NSString *)key;
+ (int64_t)wb_longlongValueForKey:(NSString *)key;

#pragma mark ------ < Operation > ------
+ (void)wb_safeRemoveObjectForKey:(NSString *)key;

@end
