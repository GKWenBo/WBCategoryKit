//
//  NSString+WBDeviceInfo.h
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface NSString (WBDeviceInfo)
/**
 *  获取当前设备运营商(详细信息)
 *
 */
+ (void)wb_check;

/**
 *  获取当前设备运营商(比如：中国移动)
 *
 *  @return 设备运营商
 */
+ (NSString *)wb_getCurrentOperatorName;

/**
 *  获得App当前版本号
 *
 *  @return App当前版本号
 */
+ (NSString *)wb_getAppCurrentVersion;

/**
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)wb_stringWithUUID;

/** << 获取应用版本 > */
+ (NSString *)wb_getApplicationVersion;

/** << 获取应用名 > */
+ (NSString *)wb_getApplicationDisplayName;

/** << 获取应用Identifier > */
+ (NSString *)wb_getIdentifier;

@end
