//
//  UITabBarItem+WBAdditional.h
//  Pods
//
//  Created by WenBo on 2019/11/21.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (WBAdditional)

/**
 *  双击 tabBarItem 时的回调，默认为 nil。
 *  @arg tabBarItem 被双击的 UITabBarItem
 *  @arg index      被双击的 UITabBarItem 的序号
 */
@property(nonatomic, copy) void (^wb_doubleTapBlock)(UITabBarItem *tabBarItem, NSInteger index);

/**
 * 获取一个UITabBarItem内显示图标的UIImageView，如果找不到则返回nil
 * @warning 需要对nil的返回值做保护
 */
- (UIImageView *)wb_imageView;

@end

NS_ASSUME_NONNULL_END
