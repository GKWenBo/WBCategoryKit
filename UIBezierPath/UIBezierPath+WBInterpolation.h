//
//  UIBezierPath+WBInterpolation.h
//  WBCategoryKit
//
//  Created by 文波 on 2025/2/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (WBInterpolation)

/// 创建圆滑贝塞尔曲线
/// - Parameters:
///   - pointsAsNSValues: 点数组
///   - closed: 是否闭合
+ (UIBezierPath *)wb_interpolateCGPointsWithHermite:(NSArray *)pointsAsNSValues
                                             closed:(BOOL)closed;

@end

NS_ASSUME_NONNULL_END
