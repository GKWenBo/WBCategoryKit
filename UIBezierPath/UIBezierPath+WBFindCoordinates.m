//
//  UIBezierPath+WBFindCoordinates.m
//  Pods
//
//  Created by 文波 on 2025/2/10.
//

#import "UIBezierPath+WBFindCoordinates.h"
#import "WBBezierCurveHelper.h"

@implementation UIBezierPath (WBFindCoordinates)

// 查找贝塞尔曲线上 x 对应的 y
- (CGFloat)wb_yValueForX:(CGFloat)x {
    return [WBBezierCurveHelper yValueForX:x inBezierPath:self];
}

@end
