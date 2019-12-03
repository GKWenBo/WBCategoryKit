//
//  WBPermission.h
//  Pods-WBCategoryKit_Example
//
//  Created by WenBo on 2019/12/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

typedef NS_ENUM(NSInteger, WBPermissionType)
{
    WBPermissionType_Location,      //定位
    WBPermissionType_Camera,        //相机
    WBPermissionType_Photos,        //相册
    WBPermissionType_Contacts,      //联系人
    WBPermissionType_Reminders,     //提醒事项
    WBPermissionType_Calendar,      //日历
    WBPermissionType_Microphone,    //麦克风
    WBPermissionType_Health,        //健康
    WBPermissionType_MediaLibrary,  //媒体库
    WBPermissionType_Speech,        //siri
    WBPermissionType_Motion,        //传感器
    WBPermissionType_Notification   //通知
};


NS_ASSUME_NONNULL_BEGIN

@protocol WBPermissionProtocol <NSObject>

@optional
/// 定位服务是否可用
+ (BOOL)wb_isServicesEnabled;

/// 是否授权
+ (BOOL)wb_authorized;

/// 授权状态
+ (NSInteger)wb_authorizationStatus;

/// 授权状态回调
/// @param completion 授权状态回调
+ (void)wb_authorizeWithCompletion:(void (^)(BOOL granted, BOOL firstTime))completion;

/// Returns YES if HealthKit is supported on the device.
+ (BOOL)wb_isHealthDataAvailable;

@end

@interface WBPermission : NSObject

/// only effective for location servince,other type reture YES
/// @param type authorization type
+ (BOOL)wb_isServicesEnabledWithType:(WBPermissionType)type;

/// whether device support the type
/// @param type authorization type
+ (BOOL)wb_isDeviceSupportedWithType:(WBPermissionType)type;

/// whether permission has been obtained, only return status, not request permission. for example, u can use this method in app setting, show permission status in most cases, suggest call "authorizeWithType:completion" method
/// @param type authorization type
+ (BOOL)wb_authorizedWithType:(WBPermissionType)type;

/// request permission and return status in main thread by block. execute block immediately when permission has been requested,else request permission and waiting for user to choose "Don't allow" or "Allow"
/// @param type authorization type
/// @param completion 请求回调
+ (void)wb_authorizeWithType:(WBPermissionType)type
                  completion:(void(^)(BOOL granted, BOOL firstTime))completion;

@end

// MARK: -------- Setting
@interface WBPermissionSetting : NSObject

/// show App privacy settings
+ (void)wb_displayAppPrivacySettings;

/// 显示去设置弹框
/// @param title 标题
/// @param message 提示文字
/// @param cancel 取消按钮
/// @param setting setting button text,if user tap this button ,will show
+ (void)wb_showAlertToDislayPrivacySettingWithTitle:(NSString*)title
                                                msg:(NSString*)message
                                             cancel:(NSString*)cancel
                                            setting:(NSString*)setting;

/// 显示去设置弹框
/// @param title 标题
/// @param message 提示文字
/// @param cancel 取消按钮
/// @param setting setting button text,if user tap this button ,will show
/// @param completion 完成回调
+ (void)wb_showAlertToDislayPrivacySettingWithTitle:(NSString*)title
                                                msg:(NSString*)message
                                             cancel:(NSString*)cancel
                                            setting:(NSString*)setting
                                         completion:(void(^ _Nullable)(void))completion;
@end

// MARK: -------- Base
@interface WBPermissionBase : NSObject <WBPermissionProtocol>

@end

// MARK: -------- Photos
@interface WBPermissionPhotos : WBPermissionBase

@end

// MARK: -------- Camera
@interface WBPermissionCamera : WBPermissionBase

@end

// MARK: -------- Contacts
@interface WBPermissionContacts : WBPermissionBase

@end

// MARK: -------- Location
@interface WBPermissionLocation : WBPermissionBase

@end

// MARK: -------- Reminders
@interface WBPermissionReminders : WBPermissionBase

@end

// MARK: -------- Reminders
@interface WBPermissionCalendar : WBPermissionBase

@end

// MARK: -------- Microphone
@interface WBPermissionMicrophone : WBPermissionBase

@end

// MARK: -------- Health
@interface WBPermissionHealth : WBPermissionBase

@end

// MARK: -------- MediaLibrary
@interface WBPermissionMediaLibrary : WBPermissionBase

@end

// MARK: -------- Data
@interface WBPermissionData : WBPermissionBase

@end

// MARK: -------- Speech
UIKIT_EXTERN API_AVAILABLE(ios(10.0), macos(10.15)) @interface WBPermissionSpeech : WBPermissionBase

@end

// MARK: -------- Motion
COREMOTION_EXPORT API_AVAILABLE(ios(11.0), watchos(4.0)) API_UNAVAILABLE(macos) @interface WBPermissionMotion : WBPermissionBase

@end

// MARK: -------- Notification
API_AVAILABLE(ios(10.0), tvos(10.0)) @interface WBPermissionNotification : WBPermissionBase

@end

NS_ASSUME_NONNULL_END
