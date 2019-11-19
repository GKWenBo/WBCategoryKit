//
//  CALayer+WBAdditional.h
//  Pods
//
//  Created by 文波 on 2019/11/19.
//


#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIkit.h>

typedef NS_OPTIONS (NSUInteger, WBUICornerMask) {
   WBUILayerMinXMinYCorner = 1U << 0,
   WBUILayerMaxXMinYCorner = 1U << 1,
   WBUILayerMinXMaxYCorner = 1U << 2,
   WBUILayerMaxXMaxYCorner = 1U << 3,
};

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (WBAdditional)

/// 是否为某个 UIView 自带的 layer
@property(nonatomic, assign, readonly) BOOL wb_isRootLayerOfView;

/**
 *  设置四个角是否支持圆角的，iOS11 及以上会调用系统的接口，否则 QMUI 额外实现
 *  @warning 如果对应的 layer 有圆角，则请使用 QMUI_Border，否则系统的 border 会被 clip 掉
 *  @warning 使用 qmui 方法，则超出 layer 范围内的内容都会被 clip 掉，系统的则不会
 *  @warning 如果使用这个接口设置圆角，那么需要获取圆角的值需要用 qmui_originCornerRadius，否则 iOS 11 以下获取到的都是 0
 */
@property(nonatomic, assign) WBUICornerMask wb_maskedCorners;

/// iOS11 以下 layer 自身的 cornerRadius 一直都是 0，圆角的是通过 mask 做的，qmui_originCornerRadius 保存了当前的圆角
@property(nonatomic, assign, readonly) CGFloat wb_originCornerRadius;

/// 移除所有动画
- (void)wb_removeDefaultAnimations;

@end

NS_ASSUME_NONNULL_END
