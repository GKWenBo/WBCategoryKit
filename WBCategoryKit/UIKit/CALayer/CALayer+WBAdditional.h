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

/**
 * 对 CALayer 执行一些操作，不以动画的形式展示过程（默认情况下修改 CALayer 的属性都会以动画形式展示出来）。
 * @param actionsWithoutAnimation 要执行的操作，可以在里面修改 layer 的属性，例如 frame、backgroundColor 等。
 * @note 如果该 layer 的任何属性修改都不需要动画，也可使用 qmui_removeDefaultAnimations。
 */
+ (void)wb_performWithoutAnimation:(void (NS_NOESCAPE ^)(void))actionsWithoutAnimation;

@end

typedef NS_OPTIONS(NSUInteger, WBUIViewBorderPosition) {
    WBUIViewBorderPositionNone      = 0,
    WBUIViewBorderPositionTop       = 1 << 0,
    WBUIViewBorderPositionLeft      = 1 << 1,
    WBUIViewBorderPositionBottom    = 1 << 2,
    WBUIViewBorderPositionRight     = 1 << 3
};

typedef NS_ENUM(NSUInteger, WBUIViewBorderLocation) {
    WBUIViewBorderLocationInside,
    WBUIViewBorderLocationCenter,
    WBUIViewBorderLocationOutside
};

/**
*  UIView (WBUI_Border) 为 UIView 方便地显示某几个方向上的边框。
*
*  系统的默认实现里，要为 UIView 加边框一般是通过 view.layer 来实现，view.layer 会给四条边都加上边框，如果你只想为其中某几条加上边框就很麻烦，于是 UIView (WBUI_Border) 提供了 WBui_borderPosition 来解决这个问题。
*  @warning 注意如果你需要为 UIView 四条边都加上边框，请使用系统默认的 view.layer 来实现，而不要用 UIView (WBUI_Border)，会浪费资源，这也是为什么 WBUIViewBorderPosition 不提供一个 WBUIViewBorderPositionAll 枚举值的原因。
*/

@interface UIView (WBBorder)

/// 设置边框的位置，默认为 wbViewBorderLocationInside，与 view.layer.border 一致。
@property(nonatomic, assign) WBUIViewBorderLocation wb_borderLocation;

/// 设置边框类型，支持组合，例如：`borderPosition = WBUIViewBorderPositionTop|WBUIViewBorderPositionBottom`。默认为 WBUIViewBorderPositionNone。
@property(nonatomic, assign) WBUIViewBorderPosition wb_borderPosition;

/// 边框的大小，默认为PixelOne。请注意修改 wb_borderPosition 的值以将边框显示出来。
@property(nonatomic, assign) IBInspectable CGFloat wb_borderWidth;

/// 边框的颜色，默认为UIColorSeparator。请注意修改 wb_borderPosition 的值以将边框显示出来。
@property(nullable, nonatomic, strong) IBInspectable UIColor *wb_borderColor;

/// 虚线 : dashPhase默认是0，且当dashPattern设置了才有效
/// wb_dashPhase 表示虚线起始的偏移，wb_dashPattern 可以传一个数组，表示“lineWidth，lineSpacing，lineWidth，lineSpacing...”的顺序，至少传 2 个。
@property(nonatomic, assign) CGFloat wb_dashPhase;
@property(nullable, nonatomic, copy) NSArray <NSNumber *> *wb_dashPattern;

/// border的layer
@property(nullable, nonatomic, strong, readonly) CAShapeLayer *wb_borderLayer;

@end

NS_ASSUME_NONNULL_END
