//
//  UIBezierPath+WBFindCoordinates.m
//  Pods
//
//  Created by 文波 on 2025/2/10.
//

#import "UIBezierPath+WBFindCoordinates.h"

// 结构体传递额外边界信息
struct WBBezierSearchContext {
    CGFloat x;
    CGFloat *resultY;
    bool found;
    CGFloat *xMin, *yMin, *xMax, *yMax;
};

// 计算直线段上的 y 值（线性插值）
CG_INLINE CGFloat wb_linearInterpolationYForX(CGFloat x, CGPoint P0, CGPoint P1) {
    if (P0.x == P1.x) return P0.y; // 避免除零
    return P0.y + (x - P0.x) * (P1.y - P0.y) / (P1.x - P0.x);
}

// 计算三阶贝塞尔曲线上的值
CG_INLINE CGFloat wb_bezierValue(CGFloat t, CGFloat P0, CGFloat P1, CGFloat P2, CGFloat P3) {
    CGFloat mt = 1 - t;
    return mt * mt * mt * P0 + 3 * mt * mt * t * P1 + 3 * mt * t * t * P2 + t * t * t * P3;
}

// 计算三阶贝塞尔曲线的导数
CG_INLINE CGFloat wb_bezierDerivative(CGFloat t, CGFloat P0, CGFloat P1, CGFloat P2, CGFloat P3) {
    CGFloat mt = 1 - t;
    return 3 * mt * mt * (P1 - P0) + 6 * mt * t * (P2 - P1) + 3 * t * t * (P3 - P2);
}

// 使用牛顿法求解 Bezier 曲线上的 Y
static CGFloat wb_bezierYForX(CGFloat x, CGPoint P0, CGPoint P1, CGPoint P2, CGPoint P3) {
    CGFloat t = 0.5; // 初始猜测值
    CGFloat tolerance = 1e-6; // 误差容限
    CGFloat tMin = 0.0, tMax = 1.0;
    for (int i = 0; i < 20; i++) { // 限制迭代次数
        CGFloat bx = wb_bezierValue(t, P0.x, P1.x, P2.x, P3.x);
        CGFloat dx = wb_bezierDerivative(t, P0.x, P1.x, P2.x, P3.x);
        if (fabs(bx - x) < tolerance) break;
        if (dx != 0) {
            t -= (bx - x) / dx;
        } else {
            t = (tMin + tMax) / 2.0;
        }
        t = fmax(tMin, fmin(t, tMax)); // 保证 t 在 [0,1] 范围内
    }
    return wb_bezierValue(t, P0.y, P1.y, P2.y, P3.y);
}

static void wb_bezierPathApplierFunc(void *info, const CGPathElement *element) {
    struct WBBezierSearchContext *context = (struct WBBezierSearchContext *)info;
    static CGPoint startPt = {0, 0};
    switch (element->type) {
        case kCGPathElementMoveToPoint:
            startPt = element->points[0];
            // 更新 x 最小/最大值
            if (startPt.x < *context->xMin) { *context->xMin = startPt.x; *context->yMin = startPt.y; }
            if (startPt.x > *context->xMax) { *context->xMax = startPt.x; *context->yMax = startPt.y; }
            break;
        case kCGPathElementAddLineToPoint: { // 处理直线段
            CGPoint endPt = element->points[0];
            // 更新边界
            if (endPt.x < *context->xMin) { *context->xMin = endPt.x; *context->yMin = endPt.y; }
            if (endPt.x > *context->xMax) { *context->xMax = endPt.x; *context->yMax = endPt.y; }
            if ((context->x >= startPt.x && context->x <= endPt.x) ||
                (context->x >= endPt.x && context->x <= startPt.x)) {
                context->found = true;
                *context->resultY = wb_linearInterpolationYForX(context->x, startPt, endPt);
            }
            startPt = endPt;
            break;
        }
        case kCGPathElementAddCurveToPoint: { // 处理曲线段
            CGPoint ctrlPt1 = element->points[0];
            CGPoint ctrlPt2 = element->points[1];
            CGPoint endPt = element->points[2];
            // 更新边界
            if (endPt.x < *context->xMin) { *context->xMin = endPt.x; *context->yMin = endPt.y; }
            if (endPt.x > *context->xMax) { *context->xMax = endPt.x; *context->yMax = endPt.y; }
            if ((context->x >= startPt.x && context->x <= endPt.x) ||
                (context->x >= endPt.x && context->x <= startPt.x)) {
                context->found = true;
                *context->resultY = wb_bezierYForX(context->x, startPt, ctrlPt1, ctrlPt2, endPt);
            }
            startPt = endPt;
            break;
        }
        default:
            break;
    }
}


@implementation UIBezierPath (WBFindCoordinates)

- (CGFloat)wb_yValueForXValue:(CGFloat)xValue {
    CGFloat resultY = FLT_MAX;
    CGFloat xMin = FLT_MAX, yMin = 0;
    CGFloat xMax = -FLT_MAX, yMax = 0;
    struct WBBezierSearchContext context =
    {
        xValue,
        &resultY,
        false,
        &xMin,
        &yMin,
        &xMax,
        &yMax
    };
    CGPathApply(self.CGPath, &context, wb_bezierPathApplierFunc);
    if (!context.found) {
        if (xValue <= xMin) return yMin;  // 低于最小 X，返回最左侧的 Y
        if (xValue >= xMax) return yMax;  // 超过最大 X，返回最右侧的 Y
    }
    return resultY;
}

@end
