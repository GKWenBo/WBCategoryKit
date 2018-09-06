//
//  NSString+WBDeviceInfo.h
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 Get CFBundleShortVersionString.

 @return NSString
 */
+ (NSString *)wb_getAppCurrentVersion;

/**
 Get random UUID string.

 @return NSString
 */
+ (NSString *)wb_stringWithUUID;

/**
 Get app verion -> CFBundleVersion

 @return NSString
 */
+ (NSString *)wb_getApplicationVersion;

/**
 Get CFBundleDisplayName string.

 @return NSString
 */
+ (NSString *)wb_getApplicationDisplayName;

/**
 Get CFBundleIdentifier string.

 @return NSString
 */
+ (NSString *)wb_getIdentifier;

/**
 Get CFBundleName

 @return NSString
 */
+ (NSString *)wb_getBoundleName;

/**
 Get the device uuid.

 @return uuid string.
 */
+ (NSString *)wb_getUUID;

@end
