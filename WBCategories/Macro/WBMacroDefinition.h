//
//  WB_MacroDefinition.h
//  WB_MacroDefinition
//
//  Created by Admin on 2017/8/9.
//  Copyright © 2017年 Admin. All rights reserved.
//

#ifndef WB_MacroDefinition_h
#define WB_MacroDefinition_h

//---------------------- ABOUT SCREEN & SIZE 屏幕&尺寸 ----------------------------
/**
 iPad Air {{0, 0}, {768, 1024}}
 iphone4s {{0, 0}, {320, 480}}               960*640
 iphone5 5s {{0, 0}, {320, 568}}             1136*640
 iphone6 6s {{0, 0}, {375, 667}}             1334*750
 iphone6Plus 6sPlus {{0, 0}, {414, 736}}     1920*1080
 iPhone X {375, 812}                         1125*2436
 Apple Watch 1.65inches(英寸)                 320*640
 */
/**  < 需要横屏或者竖屏，获取屏幕宽度与高度 当前Xcode支持iOS8及以上 >  */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
//------------------------------ 适配宏定义 ----------------------------
/**  < Adaptive  >  */
#define  kWB_AdjustsScrollViewInsets_NO(scrollView,vc)\
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

#define  kWB_AdjustsScrollViewInsets(scrollView)\
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
#define kWB_AUTOLAYOUTSIZE(size) ((size) * (SCREEN_WIDTH / 375))


//----------------------------------- 设备&系统判断 ---------------------------------------------
/**  < 判断当前的iPhone设备 >  */
#define kWB_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define IS_IPHONE ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])

/**  < 判断是否为iPad >  */
#define kWB_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define IS_IPAD ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])

/**  < 判断是否为ipod >  */
#define kWB_IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

/**  < 判断iPhone 4/iPhone 4S 像素640x960，@2x >  */
#define kWB_IS_IPHONE4_OR_4S [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f
//#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/**  < 判断是否为 iPhone5/SE/iPhone5S/iPhone5C 分辨率320x568，像素640x1136，@2x >  */
#define kWB_IS_IPHONE5_OR_SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f

/**  < 判断是否为iPhone 6/6s 分辨率375x667，像素750x1334，@2x >  */
#define kWB_IS_IPHONE6_OR_6S [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f

/**  < 判断是否为iPhone 6Plus/6sPlus 分辨率414x736，像素1242x2208，@3x >  */
#define kWB_IS_IPHONE6PLUS_OR_6SPLUS [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f

/**  < 判断是否是iPhone X >  */
#define kWB_IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/**  < 获取系统版本 >  */
#define kWB_IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/**  < 系统版本判断 >  */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**  < 判断 iOS 8 或更高的系统版本 >  */
#define kWB_SYSTEM_VERSION_8_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
//#define kWB_SYSTEM_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))

/**  < 判断 iOS 9 或更高的系统版本 >  */
#define kWB_SYSTEM_VERSION_9_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")
//#define kWB_SYSTEM_VERSION_9_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=9.0)? (YES):(NO))

/**  < 判断 iOS 11 或更高的系统版本 >  */
#define kWB_SYSTEM_VERSION_11_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")

/**  < 导航栏高度 无largeTitle >  */
#define kWB_NAVIGATIONBAR_HEIGHT 44
/**  < 状态栏高度 >  */
#define kWB_STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
/**  < 整个导航栏高度 >  */
#define kWB_NAVI_HEIGHT (kWB_IS_IPHONE_X ? (88) : (64))
/**  < 标签栏高度 >  */
#define kWB_TABBAR_HEIGHT (kWB_IS_IPHONE_X ? (83) : (49))
/**  < iOS 11 底部安全域距离 >  */
#define kWB_BOTTOM_SAFEAREA_HEIGHT (kWB_IS_IPHONE_X ? (34) : (0))

/**  < 自定义高效率log >  */
#ifdef DEBUG
#   define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define NSLog(...)
#endif

/**  < 随机色 >  */
#define kWB_RANDOM_COLOR [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

/**  < 透明色 >  */
#define kWB_CLEAR_COLOR [UIColor clearColor]

/**  < RGB颜色 >  */
#define kWB_RGB_COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

/**  < RGBA颜色 >  */
#define kWB_RGBA_COLOR(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

/**  < HEX Color >  */
#define kWB_COLORFROMHEXRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**  < 通知中心 >  */
#define kWB_NOTIFICATIONCENTER [NSNotificationCenter defaultCenter]

/**  < 系统偏好设置 >  */
#define kWB_NSUSERDEFAULTS [NSUserDefaults standardUserDefaults]

/**  < 强弱引用 >  */
#define kWB_WEAKSELF(type) __weak typeof(type) weak##type = type;
#define kWB_STRONGSELF(type) __strong typeof(type) type = weak##type;

/**  < 程序管理代理 >  */
#define kWB_APPLICATIONDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

/**  < 主窗口 >  */
#define kWB_KEYWINDOW [UIApplication sharedApplication].keyWindow
/**  < 添加视图到主窗口 >  */
#define kWB_ADDVIEWTOKEYWINDOW(view) [kWB_KEYWINDOW addSubview:view]

/**  < 协议窗口 >  */
#define kWB_APPDELEGATEWINDOW [[UIApplication sharedApplication].delegate window]

/**  < 通过文件路径获取图片 文件夹 >  */
#define kWB_IMAGEWITHFILE(imageFile) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:imageFile]]

/**  < 通过图片名获取图片 Assets >  */
#define kWB_IMAGEWITHNAME(imageName) [UIImage imageNamed:imageName]

/**  < 由角度转换弧度 >  */
#define kWB_DEGREESTORADIAN(x) (M_PI * (x) / 180.0)
/**  < 由弧度转换角度 >  */
#define kWB_RADIANTODEGREES(radian) (radian*180.0)/(M_PI)

/**  < 获取当前语言 >  */
#define kWB_CURRENTLANGUAGE [[NSLocale preferredLanguages] firstObject]

/**  < 获取沙盒 Document >  */
#define kWB_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

/**  < 获取沙盒 Cache >  */
#define kWB_CACHE_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#endif /* WB_MacroDefinition_h */

