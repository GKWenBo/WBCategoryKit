//
//  UIBezierPath+WBFindCoordinates.h
//  Pods
//
//  Created by 文波 on 2025/2/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (WBFindCoordinates)

/// 贝塞尔曲线根据X求y坐标
/// - Parameter x: x坐标
- (CGFloat)wb_yValueForX:(CGFloat)x;

@end

NS_ASSUME_NONNULL_END
