//
//  NSUserDefaults+WBAdditional.m
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "NSUserDefaults+WBAdditional.h"

NSString *const kWBVersionKey = @"kWBVersionKey";

@implementation NSUserDefaults (WBAdditional)

- (BOOL)wb_isNeedGuide {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (![[self objectForKey:kWBVersionKey] isEqualToString:version]) {
        [self setObject:version forKey:kWBVersionKey];
        [self synchronize];
        return YES;
    }
    return NO;
}

@end
