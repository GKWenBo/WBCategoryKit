//
//  UIView+WB_Additional.h
//  UIViewUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WBRectCornerType) {
    WBRectCornerTop,
    WBRectCornerLeft,
    WBRectCornerRight,
    WBRectCornerBottom,
    WBRectCornerAll
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WBAdditional)

#pragma mark -- Event
#pragma mark
/**
 *  view 添加点击事件
 *
 *  @param target 目标
 *  @param action 事件
 */
- (void)wb_addTapGestureTarget:(id)target
                        action:(SEL)action;

#pragma mark -- Border
#pragma mark
/**
 *  view 添加边框
 *
 *  @param color 边框颜色
 *  @param borderWidth 宽度
 *  @param cornerRadius 圆角
 */
- (void)wb_addBorderWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth
                 cornerRadius:(CGFloat)cornerRadius;
/**
 *  添加边框(默认圆角为4)
 *
 *  @param color 边框颜色
 */
- (void)wb_addBorderAndCornerRadiusWithColor:(UIColor *)color;
/**
 *  添加边框
 *
 *  @param color 边框颜色
 *  @param borderWidth 边框宽度
 */
- (void)wb_addBorderWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth;

#pragma mark -- CornerRadius
/**
 *  设置圆角
 *
 *  @param cornerRadius 圆角大小
 */
- (void)wb_setCornerRadius:(CGFloat)cornerRadius;

/**
 *  视图切成圆
 *
 */
- (void)wb_setCircleCornerRadius;

/**
 *  为某个方向添加指定圆角大小
 *
 *  @param rectCorner
           UIRectCornerTopLeft
           UIRectCornerTopRight
           UIRectCornerBottomLeft
           UIRectCornerBottomRight
           UIRectCornerAllCorners
 *  @param cornerRadius 圆角size
 */
- (void)wb_setBezierCornerRadiusByRoundingCorners:(WBRectCornerType)rectCorner
                                     cornerRadius:(CGFloat)cornerRadius;

#pragma mark --------  父视图  --------
/**  父视图  */
- (NSArray *)superviews;

#pragma mark --------  添加视图到Window上  --------
- (void)wb_addToWindow;

/**
 *  设置view阴影
 *
 *  @param color 颜色
 *  @param offset 偏移量
 *  @param radius 圆角
 */
- (void)wb_setLayerShadow:(nullable UIColor*)color
                   offset:(CGSize)offset
                   radius:(CGFloat)radius;

/**
 *  移除所有子视图
 *
 */
- (void)wb_removeAllSubviews;

#pragma mark --------  位置  --------
/**
 Converts a point from the receiver's coordinate system to that of the specified view or window.
 
 @param point A point specified in the local coordinate system (bounds) of the receiver.
 @param view  The view or window into whose coordinate system point is to be converted.
 If view is nil, this method instead converts to window base coordinates.
 @return The point converted to the coordinate system of view.
 */
- (CGPoint)wb_convertPoint:(CGPoint)point
            toViewOrWindow:(nullable UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)wb_convertPoint:(CGPoint)point
          fromViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)wb_convertRect:(CGRect)rect
          toViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)wb_convertRect:(CGRect)rect
        fromViewOrWindow:(nullable UIView *)view;

#pragma mark --------  绘制虚线  --------
/**
 *  绘制虚线
 *
 *  @param lineFrame 大小位置
 *  @param length 虚线长度
 *  @param spacing 间隔
 *  @param color 虚线颜色
 */
+ (UIView *)wb_createDashedLineWithFrame:(CGRect)lineFrame
                              lineLength:(int)length
                             lineSpacing:(int)spacing
                               lineColor:(UIColor *)color;

@end


@interface UIView (WBSnapshot)

#pragma mark --------  截屏  --------
/**
 *  屏幕快照
 *
 *  @return 快照图片
 */
- (nullable UIImage *)wb_snapshotImage;


/**
 *  屏幕快照 屏幕更新后处理
 *
 *  @return 快照图片
 */
- (nullable UIImage *)wb_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/**
 *  获取PDF快照
 *
 *  @return PDF data
 */
- (nullable NSData *)wb_snapshotPDF;

/**
 *  View按Rect截图
 *
 *  @param frame 截图范围
 */
- (UIImage*)wb_screenshotInFrame:(CGRect)frame;

/**
 *  ScrollView截图 contentOffset
 *
 *  @param contentOffset 偏移量
 */
- (UIImage*)wb_screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;

/**
 UIScrollView capture.

 @param scrollView scrollView.
 */
+ (UIImage *)wb_captureScrollView:(UIScrollView *)scrollView;

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
