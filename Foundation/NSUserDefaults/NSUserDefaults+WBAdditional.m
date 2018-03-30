//
//  NSUserDefaults+WBAdditional.m
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "NSUserDefaults+WBAdditional.h"

NSString *const kWBVersionKey = @"kWBAppVersionKey";

@implementation NSUserDefaults (WBAdditional)

#pragma mark ------ < 第一次启动程序 > ------
+ (BOOL)wb_isNeedGuide {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:kWBVersionKey] isEqualToString:version]) {
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:kWBVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

#pragma mark ------ < 判断 > ------
+ (BOOL)wb_checkHaveKey:(NSString *)key {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *tempKey in dict.allKeys) {
        if ([tempKey isEqualToString:key]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark ------ < 存取 > ------
+ (id)wb_objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+ (void)wb_saveObject:(id)object
               forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)wb_saveIntegerValue:(NSInteger)integerValue
                     forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:integerValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)wb_saveFloatValue:(float)floatValue
                   forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setFloat:floatValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)wb_saveDoubleValue:(double)doubleValue
                    forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setDouble:doubleValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)wb_saveBoolValue:(BOOL)boolValue
                  forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:boolValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)wb_saveLonglongValue:(int64_t)longlongValue
                      forKey:(NSString *)key {
    [self wb_saveObject:[NSNumber numberWithLongLong:longlongValue] forKey:key];
}

+ (NSInteger)wb_integerValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}
+ (BOOL)wb_boolValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
+ (float)wb_floatValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}
+ (double)wb_doubleValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}
+ (NSDictionary *)wb_dictionaryValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
}
+ (NSArray *)wb_arrayValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}
+ (NSData *)wb_dataValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] dataForKey:key];
}
+ (NSString *)wb_stringValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}
+ (int64_t)wb_longlongValueForKey:(NSString *)key {
    NSNumber *number = [self wb_objectForKey:key];
    return [number longLongValue];
}

#pragma mark ------ < Operation > ------
+ (void)wb_safeRemoveObjectForKey:(NSString *)key {
    if ([self wb_checkHaveKey:key]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}


@end
