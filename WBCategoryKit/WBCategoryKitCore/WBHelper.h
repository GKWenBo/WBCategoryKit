//
//  WBHelper.h
//  Pods
//
//  Created by WenBo on 2019/11/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBHelper : NSObject

@end

@interface WBHelper (UIGraphic)

/// 获取一像素的大小
+ (CGFloat)wb_pixelOne;

/// 判断size是否超出范围
+ (void)wb_inspectContextSize:(CGSize)size;

/// context是否合法
+ (void)wb_inspectContextIfInvalidatedInDebugMode:(CGContextRef)context;
+ (BOOL)wb_inspectContextIfInvalidatedInReleaseMode:(CGContextRef)context;

@end

@interface WBHelper (WBDevice)

/// 如 iPhone12,5、iPad6,8
+ (nonnull NSString *)wb_deviceModel;

/// 如 iPhone 11 Pro Max、iPad Pro (12.9 inch)
+ (nonnull NSString *)wb_deviceName;

+ (BOOL)wb_isIPad;
+ (BOOL)wb_isIPod;
+ (BOOL)wb_isIPhone;
+ (BOOL)wb_isSimulator;

/// 带物理凹槽的刘海屏或者使用 Home Indicator 类型的设备
+ (BOOL)wb_isNotchedScreen;

/// 将屏幕分为普通和紧凑两种，这个方法用于判断普通屏幕
+ (BOOL)wb_isRegularScreen;

/// iPhone XS Max / 11 Pro Max
+ (BOOL)wb_is65InchScreen;

/// iPhone XR / 11
+ (BOOL)wb_is61InchScreen;

/// iPhone X / XS / 11Pro
+ (BOOL)wb_is58InchScreen;

/// iPhone 8 Plus
+ (BOOL)wb_is55InchScreen;

/// iPhone 8
+ (BOOL)wb_is47InchScreen;

/// iPhone 5
+ (BOOL)wb_is40InchScreen;

/// iPhone 4
+ (BOOL)wb_is35InchScreen;

+ (CGSize)wb_screenSizeFor65Inch;
+ (CGSize)wb_screenSizeFor61Inch;
+ (CGSize)wb_screenSizeFor58Inch;
+ (CGSize)wb_screenSizeFor55Inch;
+ (CGSize)wb_screenSizeFor47Inch;
+ (CGSize)wb_screenSizeFor40Inch;
+ (CGSize)wb_screenSizeFor35Inch;

+ (CGFloat)wb_preferredLayoutAsSimilarScreenWidthForIPad;

// 用于获取 isNotchedScreen 设备的 insets，注意对于 iPad Pro 11-inch 这种无刘海凹槽但却有使用 Home Indicator 的设备，它的 top 返回0，bottom 返回 safeAreaInsets.bottom 的值
+ (UIEdgeInsets)wb_safeAreaInsetsForDeviceWithNotch;

/// 系统设置里是否开启了“放大显示-试图-放大”，支持放大模式的 iPhone 设备可在官方文档中查询 https://support.apple.com/zh-cn/guide/iphone/iphd6804774e/ios
+ (BOOL)wb_isZoomedMode;

/// 在 iPad 分屏模式下可获得实际运行区域的窗口大小，如需适配 iPad 分屏，建议用这个方法来代替 [UIScreen mainScreen].bounds.size
+ (CGSize)wb_applicationSize;

@end

@interface WBHelper (WBSystemVersion)

+ (NSInteger)wb_numbericOSVersion;
+ (NSComparisonResult)wb_compareSystemVersion:(nonnull NSString *)currentVersion
                                    toVersion:(nonnull NSString *)targetVersion;
+ (BOOL)wb_isCurrentSystemAtLeastVersion:(nonnull NSString *)targetVersion;
+ (BOOL)wb_isCurrentSystemLowerThanVersion:(nonnull NSString *)targetVersion;

@end

NS_ASSUME_NONNULL_END
