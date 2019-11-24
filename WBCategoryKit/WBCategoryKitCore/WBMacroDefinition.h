//
//  WB_MacroDefinition.h
//  WB_MacroDefinition
//
//  Created by Admin on 2017/8/9.
//  Copyright © 2017年 Admin. All rights reserved.
//

#ifndef WB_MacroDefinition_h
#define WB_MacroDefinition_h

#import "NSString+WBAddtional.h"
#import "WBHelper.h"

/// 自定义高效率log
#ifdef DEBUG
#   define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define NSLog(...)
#endif

// MARK: --------ABOUT SCREEN & SIZE 屏幕&尺寸
/**
 iPad Air {{0, 0}, {768, 1024}}
 iphone4s {{0, 0}, {320, 480}}               960*640
 iphone5 5s {{0, 0}, {320, 568}}             1136*640
 iphone6 6s {{0, 0}, {375, 667}}             1334*750
 iphone6Plus 6sPlus {{0, 0}, {414, 736}}     1920*1080
 iPhone X {375, 812}                         1125*2436
 Apple Watch 1.65inches(英寸)                 320*640
 */
/// 需要横屏或者竖屏，获取屏幕宽度与高度 当前Xcode支持iOS8及以上
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#define WB_SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define WB_SCREEN_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define WB_SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define WB_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define WB_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define WB_SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif

/// 设备宽度，跟横竖屏无关
#define WB_DEVICE_WIDTH MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

/// 设备高度，跟横竖屏无关
#define WB_DEVICE_HEIGHT MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

#define WB_SCREEN_BOUNDS [UIScreen mainScreen].bounds

/// iPhoneX 系列全面屏手机的安全区域的静态值
#define WB_SafeAreaInsetsConstantForDeviceWithNotch [WBHelper wb_safeAreaInsetsForDeviceWithNotch]

/// 状态栏高度
#define WB_StatusBarHeight (UIApplication.sharedApplication.statusBarHidden ? 0 : UIApplication.sharedApplication.statusBarFrame.size.height)
/// 状态栏高度(如果状态栏不可见，也会返回一个普通状态下可见的高度)
#define WB_StatusBarHeightConstant (UIApplication.sharedApplication.statusBarHidden ? (WB_IS_IPAD ? (WB_IS_NOTCHED_SCREEN ? 24 : 20) : WB_PreferredValueForNotchedDevice(WB_IS_LANDSCAPE ? 0 : 44, 20)) : UIApplication.sharedApplication.statusBarFrame.size.height)

/// navigationBar 的静态高度
#define WB_NavigationBarHeight (WB_IS_IPAD ? (WB_IOS_SYSTEM_VERSION >= 12.0 ? 50 : 44) : (WB_IS_LANDSCAPE ? WB_PreferredValueForVisualDevice(44, 32) : 44))

/// 代表(导航栏+状态栏)，这里用于获取其高度
/// @warn 如果是用于 viewController，请使用 UIViewController(QMUI) qmui_navigationBarMaxYInViewCoordinator 代替
#define WB_NavigationContentTop (WB_StatusBarHeight + WB_NavigationBarHeight)
/// 同上，这里用于获取它的静态常量值
#define WB_NavigationContentTopConstant (WB_StatusBarHeightConstant + WB_NavigationBarHeight)

/// tabBar相关frame
#define WB_TabBarHeight (WB_IS_IPAD ? (WB_IS_NOTCHED_SCREEN ? 65 : (WB_IOS_SYSTEM_VERSION >= 12.0 ? 50 : 49)) : (WB_IS_LANDSCAPE ? WB_PreferredValueForVisualDevice(49, 32) : 49) + WB_SafeAreaInsetsConstantForDeviceWithNotch.bottom)
/// iOS 11 底部安全域距离
#define  WB_SafeAreaInsetsBottom WB_SafeAreaInsetsConstantForDeviceWithNotch.bottom

/// 是否横竖屏
/// 用户界面横屏了才会返回YES
#define WB_IS_LANDSCAPE UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)
/// 无论支不支持横屏，只要设备横屏了，就会返回YES
#define WB_IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

/// 区分全面屏（iPhone X 系列）和非全面屏
#define WB_PreferredValueForNotchedDevice(_notchedDevice, _otherDevice) ([WBHelper wb_isNotchedScreen] ? _notchedDevice : _otherDevice)
/// 将所有屏幕按照宽松/紧凑分类，其中 iPad、iPhone XS Max/XR/Plus 均为宽松屏幕，但开启了放大模式的设备均会视为紧凑屏幕
#define WB_PreferredValueForVisualDevice(_regular, _compact) ([WBHelper wb_isRegularScreen] ? _regular : _compact)

// MARK: -------- 适配宏定义
/// Adaptive
#define WB_AdjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

#define  WB_AdjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

/**  < 屏幕适配 ipone6/6s 控件宽高 字体大小都可以用这个宏 >  */
#define WB_AUTOLAYOUTSIZE(size) ((size) * (WB_DEVICE_WIDTH / 375))

#define WB_VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

///屏幕像素
#define WB_SCREEN_SCALE [UIScreen mainScreen].scale

// MARK: --------设备&系统判断
///判断当前的iPhone设备
#define WB_IS_IPHONE [WBHelper wb_isIPhone]
//#define WB_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
///是否是模拟器
#define WB_IS_SIMULATOR [WBHelper wb_isSimulator]
/// 判断是否为iPad
#define WB_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define IS_IPAD ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
/// 判断是否为ipod
#define WB_IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
/// 是否全面屏设备
#define WB_IS_NOTCHED_SCREEN [WBHelper wb_isNotchedScreen]
/// iPhone X/XS
#define WB_IS_58INCH_SCREEN [WBHelper wb_is58InchScreen]
/// iPhone XS Max
#define WB_IS_65INCH_SCREEN [WBHelper wb_is65InchScreen]
/// iPhone XR
#define WB_IS_61INCH_SCREEN [WBHelper wb_is61InchScreen]
/// iPhone 6/7/8 Plus
#define WB_IS_55INCH_SCREEN [WBHelper wb_is55InchScreen]
/// iPhone 6/7/8
#define WB_IS_47INCH_SCREEN [WBHelper wb_is47InchScreen]
/// iPhone 5/5S/SE
#define WB_IS_40INCH_SCREEN [WBHelper wb_is40InchScreen]
/// iPhone 4/4S
#define WB_IS_35INCH_SCREEN [WBHelper wb_is35InchScreen]
/// iPhone 4/4S/5/5S/SE
#define WB_IS_320WIDTH_SCREEN (WB_IS_35INCH_SCREEN || WB_IS_40INCH_SCREEN)
/// 判断iPhone 4/iPhone 4S 像素640x960，@2x
//#define WB_IS_IPHONE4_OR_4S [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f
//#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
/// 判断是否为 iPhone5/SE/iPhone5S/iPhone5C 分辨率320x568，像素640x1136，@2x
//#define WB_IS_IPHONE5_OR_SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
/// 判断是否为iPhone 6/6s 分辨率375x667，像素750x1334，@2x
//#define WB_IS_IPHONE6_OR_6S [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
/// 判断是否为iPhone 6Plus/6sPlus 分辨率414x736，像素1242x2208，@3x
//#define WB_IS_IPHONE6PLUS_OR_6SPLUS [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f

/// 是否Retina
#define WB_IS_RETINASCREEN ([[UIScreen mainScreen] scale] >= 2.0)

/// 是否放大模式（iPhone 6及以上的设备支持放大模式，iPhone X 除外）
#define WB_IS_ZOOMEDMODE [WBHelper wb_isZoomedMode]

/// 判断是否是iPhone X
#define WB_IS_iPHoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/// 获取系统版本
#define WB_IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/// 数字形式的操作系统版本号，可直接用于大小比较；如 110205 代表 11.2.5 版本；根据 iOS 规范，版本号最多可能有3位
#define WB_IOS_VERSION_NUMBER [WBHelper wb_numbericOSVersion]

/// 系统版本判断
#define WB_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define WB_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define WB_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define WB_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define WB_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/// 判断 iOS 8 或更高的系统版本
#define WB_SYSTEM_VERSION_8_OR_LATER WB_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
//#define kWB_SYSTEM_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))

/// 判断 iOS 9 或更高的系统版本
#define WB_SYSTEM_VERSION_9_OR_LATER WB_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")
//#define kWB_SYSTEM_VERSION_9_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=9.0)? (YES):(NO))

/// 判断 iOS 11 或更高的系统版本
#define WB_SYSTEM_VERSION_11_OR_LATER WB_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")

// MARK: -------- 颜色相关
/// 随机色
#define WB_RANDOM_COLOR [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
/// 透明色
#define WB_CLEAR_COLOR [UIColor clearColor]
/// RGB颜色
#define WB_RGB_COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
/// RGBA颜色
#define WB_RGBA_COLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
/// HEX Color
#define WB_COLORFROMHEXRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// MARK: -------- 系统单例
/// 通知中心
#define WB_NOTIFICATIONCENTER [NSNotificationCenter defaultCenter]
/// 系统偏好设置
#define WB_NSUSERDEFAULTS [NSUserDefaults standardUserDefaults]

/// 强弱引用
#define WB_WEAKSELF(type) __weak typeof(type) weak##type = type;
#define WB_STRONGSELF(type) __strong typeof(type) type = weak##type;

// MARK: ------- 解决循环引用
#define WB_WeakObjc(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define WB_StrongObjc(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

/// 程序管理代理
#define WB_APPLICATIONDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
/// 主窗口
#define WB_KEYWINDOW [UIApplication sharedApplication].keyWindow
/// 添加视图到主窗口
#define WB_ADDVIEWTOKEYWINDOW(view) [kWB_KEYWINDOW addSubview:view]
/// 协议窗口
#define WB_APPDELEGATEWINDOW [[UIApplication sharedApplication].delegate window]

// MARK: -------- 加载图片
/// 通过文件路径获取图片 文件夹
#define WB_IMAGEWITHFILE(imageFile) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:imageFile]]
/// 通过图片名获取图片 Assets
#define WB_IMAGEWITHNAME(imageName) [UIImage imageNamed:imageName]

/// 由角度转换弧度
#define WB_DEGREESTORADIAN(x) (M_PI * (x) / 180.0)
/// 由弧度转换角度
#define WB_RADIANTODEGREES(radian) (radian*180.0)/(M_PI)

/// 获取当前语言
#define WB_CURRENTLANGUAGE [[NSLocale preferredLanguages] firstObject]

// MARK: -------- 沙盒路径获取
/// 获取沙盒 Document
#define WB_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
/// 获取沙盒 Cache
#define WB_CACHE_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

// MARK: --------同步锁
#define WB_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define WB_UNLOCK(lock) dispatch_semaphore_signal(lock);

// MARK: -------- 多线程
/** < 主线程安全执行 >  */
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

/// 子线程安全执行
#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(queue)) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

// MARK: -------- INLINE函数
CG_INLINE CGRect
WBCGRectMakeWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

/// 判断一个 CGSize 是否为空（宽或高为0）
CG_INLINE BOOL
WBCGSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}

/// 判断一个 CGSize 是否存在 infinite
CG_INLINE BOOL
WBCGSizeIsInf(CGSize size) {
    return isinf(size.width) || isinf(size.height);
}

/// 判断一个 CGSize 是否存在 NaN
CG_INLINE BOOL
WBCGSizeIsNaN(CGSize size) {
    return isnan(size.width) || isnan(size.height);
}


/// 判断一个 CGSize 是否合法（例如不带无穷大的值、不带非法数字）
CG_INLINE BOOL
WBCGSizeIsValidated(CGSize size) {
    return !WBCGSizeIsEmpty(size) && !WBCGSizeIsInf(size) && !WBCGSizeIsNaN(size);
}

/**
*  某些地方可能会将 CGFLOAT_MIN 作为一个数值参与计算（但其实 CGFLOAT_MIN 更应该被视为一个标志位而不是数值），可能导致一些精度问题，所以提供这个方法快速将 CGFLOAT_MIN 转换为 0
*  issue: https://github.com/Tencent/QMUI_iOS/issues/203
*/
CG_INLINE CGFloat wb_removeFloatMin(CGFloat floatValue) {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

/**
*  基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
*
*  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
*/
CG_INLINE CGFloat wb_flatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = wb_removeFloatMin(floatValue);
    scale = scale ?: [UIScreen mainScreen].scale;
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

/**
*  基于当前设备的屏幕倍数，对传进来的 floatValue 进行像素取整。
*
*  注意如果在 Core Graphic 绘图里使用时，要注意当前画布的倍数是否和设备屏幕倍数一致，若不一致，不可使用 flat() 函数，而应该用 flatSpecificScale
*/

CG_INLINE CGFloat wb_flat(CGFloat floatValue) {
    return wb_flatSpecificScale(floatValue, 0);
}

/// 将一个 CGSize 像素对齐
CG_INLINE CGSize
WBCGSizeFlatted(CGSize size) {
    return CGSizeMake(wb_flat(size.width), wb_flat(size.height));
}

/// 计算view的垂直居中，传入父view和子view的frame，返回子view在垂直居中时的y值
CG_INLINE CGFloat
WBCGRectGetMinYVerticallyCenterInParentRect(CGRect parentRect, CGRect childRect) {
    return wb_flat((CGRectGetHeight(parentRect) - CGRectGetHeight(childRect)) / 2.0);
}

/// 返回值：同一个坐标系内，想要layoutingRect和已布局完成的referenceRect保持垂直居中时，layoutingRect的originY
CG_INLINE CGFloat
WBCGRectGetMinYVerticallyCenter(CGRect referenceRect, CGRect layoutingRect) {
    return CGRectGetMinY(referenceRect) + WBCGRectGetMinYVerticallyCenterInParentRect(referenceRect, layoutingRect);
}

/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
WBUIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
WBUIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

/// 为给定的rect往内部缩小insets的大小
CG_INLINE CGRect
WBCGRectInsetEdges(CGRect rect, UIEdgeInsets insets) {
    rect.origin.x += insets.left;
    rect.origin.y += insets.top;
    rect.size.width -= WBUIEdgeInsetsGetHorizontalValue(insets);
    rect.size.height -= WBUIEdgeInsetsGetVerticalValue(insets);
    return rect;
}


CG_INLINE CGRect
WBCGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = wb_flat(y);
    return rect;
}

#pragma mark - Selector
/**
 根据给定的 getter selector 获取对应的 setter selector
 @param getter 目标 getter selector
 @return 对应的 setter selector
 */
CG_INLINE SEL
wb_setterWithGetter(SEL getter) {
    NSString *getterString = NSStringFromSelector(getter);
    NSMutableString *setterString = [[NSMutableString alloc] initWithString:@"set"];
    [setterString appendString:getterString.wb_capitalizedString];
    [setterString appendString:@":"];
    SEL setter = NSSelectorFromString(setterString);
    return setter;
}

#pragma mark - 变量-编译相关
/// 判断当前是否debug编译模式
#ifdef DEBUG
#define WB_IS_DEBUG YES
#else
#define WB_IS_DEBUG NO
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
/// 当前编译使用的 Base SDK 版本为 iOS 9.0 及以上
#define WB_IOS9_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
/// 当前编译使用的 Base SDK 版本为 iOS 10.0 及以上
#define WB_IOS10_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
/// 当前编译使用的 Base SDK 版本为 iOS 11.0 及以上
#define WB_IOS11_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120000
/// 当前编译使用的 Base SDK 版本为 iOS 12.0 及以上
#define WB_IOS12_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
/// 当前编译使用的 Base SDK 版本为 iOS 13.0 及以上
#define  WB_IOS13_SDK_ALLOWED YES
#endif

/// MARK: -------- 设置平方字体PingFangSC
///苹方字体常规
#define WBPFR_FONT_SIZE(s) [UIFont fontWithName:@"PingFangSC-Regular" size:s]
///苹方字体中等
#define WBPFM_FONT_SIZE(s) [UIFont fontWithName:@"PingFangSC-Medium" size:s]
///平方字体粗体
#define WBPFB_FONT_SIZE(s) [UIFont fontWithName:@"PingFangSC-Semibold" size:s]
///系统字体
#define WBSYS_FONT_SIZE(s) [UIFont systemFontOfSize:s]
///系统字体加粗
#define WBSYSB_FONT_SIZE(s) [UIFont boldSystemFontOfSize:s]

// MARK: -------- 清除警告
/*
 1、清除警告基本语法
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "警告名称"
 //被夹在这中间的代码针对于此警告都会无视并且不显示出来
 #pragma clang diagnostic pop
 
 2、Example
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wdeprecated-declarations"
 return [@"contentText" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320, CGFLOAT_MAX) lineBreakMode:0];
 #pragma clang diagnostic pop
 
 3、常见编译警告类型
 -Wincompatible-pointer-types    指针类型不匹配
 -Wincomplete-implementation     没有实现已声明的方法
 -Wprotocol                      没有实现协议的方法
 -Wimplicit-function-declaration 尚未声明的函数(通常指c函数)
 -Warc-performSelector-leaks     使用performSelector可能会出现泄漏(该警告在xcode4.3.1中没出现过,网上流传说4.2使用performselector:withObject: 就会得到该警告)
 -Wdeprecated-declarations       使用了不推荐使用的方法(如[UILabel setFont:(UIFont*)])
 -Wunused-variable               含有没有被使用的变量
 -Wundeclared-selector           未定义selector方法
 
 4、忽略cocoapod引入的第三方警告
 pod 'Alamofire', '~> 3.0.0-beta.3', :inhibit_warnings => true
 
 */

///PerformSelector警告
#define WB_SUPPRESS_PerformSelectorLeak_WARNING(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

///忽略未定义方法警告
#define  WB_SUPPRESS_Undeclaredselector_WARNING(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

///忽略过期API警告
#define WB_SUPPRESS_DEPRECATED_WARNING(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

///未使用定义
#define WB_SUPPRESS_UNUSEDVALUE_WARNING(Stuff)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wunused-value\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/// 参数可直接传入 clang 的 warning 名，warning 列表参考：https://clang.llvm.org/docs/DiagnosticsReference.html
#define WBArgumentToString(macro) #macro
#define WBClangWarningConcat(warning_name) WBArgumentToString(clang diagnostic ignored warning_name)

#define WBBeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(WBClangWarningConcat(#warningName))
#define WBEndIgnoreClangWarning _Pragma("clang diagnostic pop")

#define WBBeginIgnorePerformSelectorLeaksWarning WBBeginIgnoreClangWarning(-Warc-performSelector-leaks)
#define WBEndIgnorePerformSelectorLeaksWarning WBEndIgnoreClangWarning

#define WBBeginIgnoreAvailabilityWarning WBBeginIgnoreClangWarning(-Wpartial-availability)
#define WBEndIgnoreAvailabilityWarning WBEndIgnoreClangWarning

#define WBBeginIgnoreDeprecatedWarning WBBeginIgnoreClangWarning(-Wdeprecated-declarations)
#define WBEndIgnoreDeprecatedWarning WBEndIgnoreClangWarning

// MARK: -------- 忽略 iOS 13 KVC 访问私有属性限制
#define WBBeginIgnoreUIKVCAccessProhibited if (@available(iOS 13.0, *)) NSThread.currentThread.wb_shouldIgnoreUIKVCAccessProhibited = YES;
#define WBEndIgnoreUIKVCAccessProhibited if (@available(iOS 13.0, *)) NSThread.currentThread.wb_shouldIgnoreUIKVCAccessProhibited = NO;

#endif /* WB_MacroDefinition_h */

