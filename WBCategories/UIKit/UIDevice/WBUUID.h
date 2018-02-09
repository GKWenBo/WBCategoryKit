//
//  WBUUID.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

/**  <
    GitHub：https://github.com/fabiocaccamo/FCUUID
    Author：Fabio Caccamo
 >  */

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const WBUUIDsOfUserDevicesDidChangeNotification;

@interface WBUUID : NSObject
{
    NSMutableDictionary *_uuidForKey;
    NSString *_uuidForSession;
    NSString *_uuidForInstallation;
    NSString *_uuidForVendor;
    NSString *_uuidForDevice;
    NSString *_uuidsOfUserDevices;
    BOOL _uuidsOfUserDevices_iCloudAvailable;
}

/**
 单例管理类

 @return WBUUID
 */
+ (instancetype)sharedInstance;

+ (NSString *)uuid;
+ (NSString *)uuidForKey:(id<NSCopying>)key;
+ (NSString *)uuidForSession;
+ (NSString *)uuidForInstallation;
+ (NSString *)uuidForVendor;
+ (NSString *)uuidForDevice;
+ (NSString *)uuidForDeviceMigratingValue:(NSString *)value commitMigration:(BOOL)commitMigration;
+ (NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key commitMigration:(BOOL)commitMigration;
+ (NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key service:(NSString *)service commitMigration:(BOOL)commitMigration;
+ (NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup commitMigration:(BOOL)commitMigration;
+ (NSArray *)uuidsOfUserDevices;
+ (NSArray *)uuidsOfUserDevicesExcludingCurrentDevice;


/**
 Check uuid value is valid.

 @param uuidValue uuid
 @return YES/NO
 */
+ (BOOL)uuidValueIsValid:(NSString *)uuidValue;

@end
