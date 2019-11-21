//
//  UITabBar+WBAdditional.h
//  Pods
//
//  Created by WenBo on 2019/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (WBAdditional)

/**
 UITabBar 的背景 view，可能显示磨砂、背景图，顶部有一部分溢出到 UITabBar 外。
 
 在 iOS 10 及以后是私有的 _UIBarBackground 类。
 
 在 iOS 9 及以前是私有的 _UITabBarBackgroundView 类。
 */
@property(nonatomic, strong, readonly) UIView *wb_backgroundView;

/**
 qmui_backgroundView 内的 subview，用于显示顶部分隔线 shadowImage，注意这个 view 是溢出到 qmui_backgroundView 外的。若 shadowImage 为 [UIImage new]，则这个 view 的高度为 0。
 */
@property(nonatomic, strong, readonly) UIImageView *wb_shadowImageView;

// MARK: Configuration Property
@property(nonatomic, strong, nullable) UIImage  *wb_tabBarBackgroundImage;
@property(nonatomic, strong, nullable) UIColor  *wb_tabBarBarTintColor;
@property(nonatomic, strong, nullable) UIColor  *wb_tabBarShadowImageColor;
@property(nonatomic, assign) UIBarStyle         wb_tabBarStyle;
@property(nonatomic, strong, nullable) UIFont   *wb_tabBarItemTitleFont;
@property(nonatomic, strong, nullable) UIColor  *wb_tabBarItemTitleColor;
@property(nonatomic, strong, nullable) UIColor  *wb_tabBarItemTitleColorSelected;
@property(nonatomic, strong, nullable) UIColor  *wb_tabBarItemImageColor;
@property(nonatomic, strong, nullable) UIColor  *wb_tabBarItemImageColorSelected;

@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000

UIKIT_EXTERN API_AVAILABLE(ios(13.0), tvos(13.0)) @interface UITabBarAppearance (WBAdditional)

/**
 同时设置 stackedLayoutAppearance、inlineLayoutAppearance、compactInlineLayoutAppearance 三个状态下的 itemAppearance
 */
- (void)wb_applyItemAppearanceWithBlock:(void (^)(UITabBarItemAppearance *itemAppearance))block;

@end

#endif

NS_ASSUME_NONNULL_END
