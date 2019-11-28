//
//  WBUICollectionViewPagingLayout.h
//  Pods
//
//  Created by WenBo on 2019/11/28.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBUICollectionViewPagingLayoutStyle) {
    WBUICollectionViewPagingLayoutStyleDefault, // 普通模式，水平滑动
    WBUICollectionViewPagingLayoutStyleScale,   // 缩放模式，两边的item会小一点，逐渐向中间放大
    WBUICollectionViewPagingLayoutStyleRotation // 旋转模式，围绕底部某个点为中心旋转
};

NS_ASSUME_NONNULL_BEGIN

/**
*  支持按页横向滚动的 UICollectionViewLayout，可切换不同类型的滚动动画。
*
*  @warning item 的大小和布局仅支持通过 UICollectionViewFlowLayout 的 property 系列属性修改，也即每个 item 都应相等。对于通过 delegate 方式返回各不相同的 itemSize、sectionInset 的场景是不支持的。
*/
@interface WBUICollectionViewPagingLayout : UICollectionViewFlowLayout

- (instancetype)initWithStyle:(WBUICollectionViewPagingLayoutStyle)style NS_DESIGNATED_INITIALIZER;

@property(nonatomic, assign, readonly) WBUICollectionViewPagingLayoutStyle style;

/**
 *  规定超过这个滚动速度就强制翻页，从而使翻页更容易触发。默认为 0.4
 */
@property(nonatomic, assign) CGFloat velocityForEnsurePageDown;

/**
 *  是否支持一次滑动可以滚动多个 item，默认为 YES
 */
@property(nonatomic, assign) BOOL allowsMultipleItemScroll;

/**
 *  规定了当支持一次滑动允许滚动多个 item 的时候，滑动速度要达到多少才会滚动多个 item，默认为 2.5
 *
 *  仅当 allowsMultipleItemScroll 为 YES 时生效
 */
@property(nonatomic, assign) CGFloat multipleItemScrollVelocityLimit;

@end

@interface WBUICollectionViewPagingLayout (WBDefaultStyle)

/// 当前 cell 的百分之多少滚过临界点时就会触发滚到下一张的动作，默认为 .666，也即超过 2/3 即会滚到下一张。
/// 对应地，触发滚到上一张的临界点将会被设置为 (1 - pagingThreshold)
@property(nonatomic, assign) CGFloat pagingThreshold;

/// 打开时，会在 collectionView.backgroundView 上添加一条红线，用来标志分页的参考点位置。仅对 Default style 有效。
@property(nonatomic, assign) BOOL debug;

@end

@interface WBUICollectionViewPagingLayout (WBScaleStyle)

/**
 *  中间那张卡片基于初始大小的缩放倍数，默认为 1.0
 */
@property(nonatomic, assign) CGFloat maximumScale;

/**
 *  除了中间之外的其他卡片基于初始大小的缩放倍数，默认为 0.9
 */
@property(nonatomic, assign) CGFloat minimumScale;

@end

extern const CGFloat WBUICollectionViewPagingLayoutRotationRadiusAutomatic;

@interface WBUICollectionViewPagingLayout (WBRotationStyle)

/**
 *  旋转卡片相关
 *  左右两个卡片最终旋转的角度有 rotationRadius * 90 计算出来
 *  rotationRadius表示旋转的半径
 *  @warning 仅当 style 为 QMUICollectionViewPagingLayoutStyleRotation 时才生效
 */
@property(nonatomic, assign) CGFloat rotationRatio;
@property(nonatomic, assign) CGFloat rotationRadius;

@end

NS_ASSUME_NONNULL_END
