//
//  UIBarItem+WBAdditional.h
//  Pods
//
//  Created by WenBo on 2019/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarItem (WBAdditional)

/**
 获取 UIBarItem（UIBarButtonItem、UITabBarItem） 内部的 view，通常对于 navigationItem 而言，需要在设置了 navigationItem 后并且在 navigationBar 可见时（例如 viewDidAppear: 及之后）获取 UIBarButtonItem.qmui_view 才有值。
 
 @return 当 UIBarButtonItem 作为 navigationItem 使用时，iOS 10 及以前返回 UINavigationButton，iOS 11 及以后返回 _UIButtonBarButton；当作为 toolbarItem 使用时，iOS 10 及以前返回 UIToolbarButton，iOS 11 及以后返回 _UIButtonBarButton。对于 UITabBarItem，不管任何 iOS 版本均返回 UITabBarButton。
 
 @note 可以通过 qmui_viewDidSetBlock 监听 qmui_view 值的变化，从而无需等待 viewDidAppear: 之类的时机。
 
 @warning 仅对 UIBarButtonItem、UITabBarItem 有效
 */
@property(nullable, nonatomic, weak, readonly) UIView *wb_view;

@end

NS_ASSUME_NONNULL_END
