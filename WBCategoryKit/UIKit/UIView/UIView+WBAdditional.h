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

// MARK: - Initializer
/// 相当于 initWithFrame:CGRectMake(0, 0, size.width, size.height)
/// @param size 初始化size
- (instancetype)wb_initWithSize:(CGSize)size;

// MARK: - Property

/// 在 iOS 11 及之后的版本，此属性将返回系统已有的 self.safeAreaInsets。在之前的版本此属性返回 UIEdgeInsetsZero
@property (nonatomic, assign, readonly) UIEdgeInsets wb_safeAreaInsets;

///  将要设置的 frame 用 CGRectApplyAffineTransformWithAnchorPoint 处理后再设置
@property (nonatomic, assign) CGRect wb_frameApplyTransform;

/// 有修改过 tintColor，则不会再受 superview.tintColor 的影响
@property (nonatomic, assign, readonly) BOOL wb_tintColorCustomized;

#pragma mark - Event

/// view 添加点击事件
/// @param target 目标
/// @param action 事件
- (void)wb_addTapGestureTarget:(id)target
                        action:(SEL)action;

#pragma mark - Border

/// 添加边框
/// @param color 边框颜色
/// @param borderWidth 宽度
/// @param cornerRadius 圆角
- (void)wb_addBorderWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth
                 cornerRadius:(CGFloat)cornerRadius;

/// 添加边框(默认圆角为4)
/// @param color 边框颜色
- (void)wb_addBorderAndCornerRadiusWithColor:(UIColor *)color;

/// 添加边框
/// @param color 边框颜色
/// @param borderWidth 边框宽度
- (void)wb_addBorderWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth;

#pragma mark - CornerRadius
/// 设置圆角
/// @param cornerRadius 圆角大小
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

#pragma mark - 父视图
/**  父视图  */
- (NSArray *)superviews;

#pragma mark - 添加视图到Window上
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

#pragma mark - 位置
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

#pragma mark - 绘制虚线
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

// MARK: - Methods
+ (void)wb_animateWithAnimated:(BOOL)animated
                      duration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                       options:(UIViewAnimationOptions)options
                    animations:(void (^)(void))animations
                    completion:(void (^ __nullable)(BOOL finished))completion;
+ (void)wb_animateWithAnimated:(BOOL)animated
                      duration:(NSTimeInterval)duration
                    animations:(void (^ __nullable)(void))animations
                    completion:(void (^ __nullable)(BOOL finished))completion;
+ (void)wb_animateWithAnimated:(BOOL)animated
                      duration:(NSTimeInterval)duration
                    animations:(void (^ __nullable)(void))animations;
+ (void)wb_animateWithAnimated:(BOOL)animated
                      duration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
        usingSpringWithDamping:(CGFloat)dampingRatio
         initialSpringVelocity:(CGFloat)velocity
                       options:(UIViewAnimationOptions)options
                    animations:(void (^)(void))animations
                    completion:(void (^)(BOOL finished))completion;

@end


#pragma mark - 截屏
@interface UIView (WBSnapshot)

/// 屏幕快照
- (nullable UIImage *)wb_snapshotImage;

/// 屏幕快照 屏幕更新后处理
/// @param afterUpdates <#afterUpdates description#>
- (nullable UIImage *)wb_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;


/// 获取PDF快照
- (nullable NSData *)wb_snapshotPDF;

/// View按Rect截图
/// @param frame 截取大小
- (UIImage*)wb_screenshotInFrame:(CGRect)frame;

/// ScrollView截图 contentOffset
/// @param contentOffset 偏移量
- (UIImage*)wb_screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;

/// UIScrollView capture.
/// @param scrollView scrollView.
+ (UIImage *)wb_captureScrollView:(UIScrollView *)scrollView;

@end

@interface UIView (WBBlock)

/**
 在 UIView 的 frame 变化前会调用这个 block，变化途径包括 setFrame:、setBounds:、setCenter:、setTransform:，你可以通过返回一个 rect 来达到修改 frame 的目的，最终执行 [super setFrame:] 时会使用这个 block 的返回值（除了 setTransform: 导致的 frame 变化）。
 @param view 当前的 view 本身，方便使用，省去 weak 操作
 @param followingFrame setFrame: 的参数 frame，也即即将被修改为的 rect 值
 @return 将会真正被使用的 frame 值
 @note 仅当 followingFrame 和 self.frame 值不相等时才会被调用
 */
@property (nullable, nonatomic, copy) CGRect (^wb_frameWillChangeBlock)(__kindof UIView *view, CGRect followingFrame);

/**
 在 UIView 的 frame 变化后会调用这个 block，变化途径包括 setFrame:、setBounds:、setCenter:、setTransform:，可用于监听布局的变化，或者在不方便重写 layoutSubviews 时使用这个 block 代替。
 @param view 当前的 view 本身，方便使用，省去 weak 操作
 @param precedingFrame 修改前的 frame 值
 */
@property (nullable, nonatomic, copy) void (^wb_frameDidChangeBlock)(__kindof UIView *view, CGRect precedingFrame);

/**
 在 UIView 的 layoutSubviews 调用后的下一个 runloop 调用。如果不放到下一个 runloop，直接就调用，会导致先于子类重写的 layoutSubviews 就调用，这样就无法获取到正确的 subviews 的布局。
 @param view 当前的 view 本身，方便使用，省去 weak 操作
 @note 如果某些 view 重写了 layoutSubviews 但没有调用 super，则这个 block 也不会被调用
 */
@property (nullable, nonatomic, copy) void (^wb_layoutSubviewsBlock)(__kindof UIView *view);

/**
 当 tintColorDidChange 被调用的时候会调用这个 block，就不用重写方法了
 @param view 当前的 view 本身，方便使用，省去 weak 操作
 */
@property (nullable, nonatomic, copy) void (^wb_tintColorDidChangeBlock)(__kindof UIView *view);

/**
 当 hitTest:withEvent: 被调用时会调用这个 block，就不用重写方法了
 @param point 事件产生的 point
 @param event 事件
 @param super 的返回结果
 */
@property (nullable, nonatomic, copy) __kindof UIView * (^wb_hitTestBlock)(CGPoint point, UIEvent *event, __kindof UIView *originalView);

@end

// MARK: - Layout
@interface UIView (WBFrame)

///< Shortcut for frame.origin.x.
@property (nonatomic, assign) CGFloat wb_left;
///< Shortcut for frame.origin.y
@property (nonatomic, assign) CGFloat wb_top;
///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat wb_right;
///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat wb_bottom;
///< Shortcut for frame.size.width.
@property (nonatomic, assign) CGFloat wb_width;
///< Shortcut for frame.size.height.
@property (nonatomic, assign) CGFloat wb_height;
///< Shortcut for center.x
@property (nonatomic, assign) CGFloat wb_centerX;
///< Shortcut for center.y
@property (nonatomic, assign) CGFloat wb_centerY;
///< Shortcut for frame.origin.
@property (nonatomic, assign) CGPoint wb_origin;
///< Shortcut for frame.size.
@property (nonatomic, assign) CGSize  wb_size;
/// 最大x值
@property (nonatomic, assign) CGFloat wb_maxX;
/// 最大值
@property (nonatomic, assign) CGFloat wb_maxY;

@end

NS_ASSUME_NONNULL_END
