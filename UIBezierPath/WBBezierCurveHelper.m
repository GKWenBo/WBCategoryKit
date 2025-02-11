//
//  WBBezierCurveHelper.m
//  Pods
//
//  Created by wenbo22 on 2025/2/11.
//

#import "WBBezierCurveHelper.h"

@implementation WBBezierCurveHelper

// 结构体：用于 CGPathApply 传递数据
struct BezierSearchContext {
    CGFloat x;          // 目标 X 值
    CGFloat *resultY;   // 计算出的 Y 值
    bool found;         // 是否找到对应 X 的 Y
    CGFloat xMin, yMin; // 路径最小 X 和对应 Y
    CGFloat xMax, yMax; // 路径最大 X 和对应 Y
    CGPoint firstPoint; // 记录第一个点，处理 CloseSubpath
    bool hasMoveTo;     // 是否已有 MoveToPoint
};

// 计算两点之间的线性插值
static CGFloat linearInterpolationYForX(CGFloat x, CGPoint p1, CGPoint p2) {
    if (fabs(p1.x - p2.x) < 1e-6) return p1.y; // 避免除零错误
    return p1.y + (x - p1.x) * (p2.y - p1.y) / (p2.x - p1.x);
}

// 计算二次贝塞尔曲线上 x 对应的 y
static CGFloat quadraticBezierYForX(CGFloat x, CGPoint p0, CGPoint p1, CGPoint p2) {
    CGFloat t = (x - p0.x) / (p2.x - p0.x); // 近似求解 t
    CGFloat oneMinusT = 1.0 - t;
    return oneMinusT * oneMinusT * p0.y + 2.0 * oneMinusT * t * p1.y + t * t * p2.y;
}

// 计算三次贝塞尔曲线上 x 对应的 y
static CGFloat bezierYForX(CGFloat x, CGPoint p0, CGPoint p1, CGPoint p2, CGPoint p3) {
    CGFloat t = 0.5, tMin = 0, tMax = 1;
    for (int i = 0; i < 10; i++) { // 迭代 10 次
        CGFloat xt = (1 - t) * (1 - t) * (1 - t) * p0.x
                   + 3 * (1 - t) * (1 - t) * t * p1.x
                   + 3 * (1 - t) * t * t * p2.x
                   + t * t * t * p3.x;
        CGFloat dx_dt = -3 * (1 - t) * (1 - t) * p0.x
                        + 3 * (1 - 4 * t + 3 * t * t) * p1.x
                        + 3 * (2 * t - 3 * t * t) * p2.x
                        + 3 * t * t * p3.x;
        if (fabs(dx_dt) < 1e-6) break; // 避免除零错误
        CGFloat tNext = t - (xt - x) / dx_dt;
        if (tNext < tMin) tNext = tMin;
        if (tNext > tMax) tNext = tMax;
        if (fabs(tNext - t) < 1e-6) break; // 迭代收敛
        t = tNext;
    }
    return (1 - t) * (1 - t) * (1 - t) * p0.y
         + 3 * (1 - t) * (1 - t) * t * p1.y
         + 3 * (1 - t) * t * t * p2.y
         + t * t * t * p3.y;
}

// CGPath 遍历函数
void BezierPathApplierFunc(void *info, const CGPathElement *element) {
    struct BezierSearchContext *context = (struct BezierSearchContext *)info;
    static CGPoint startPt = {0, 0};

    switch (element->type) {
        case kCGPathElementMoveToPoint:
            startPt = element->points[0];
            context->firstPoint = startPt;
            context->hasMoveTo = true;
            context->xMin = startPt.x;
            context->yMin = startPt.y;
            context->xMax = startPt.x;
            context->yMax = startPt.y;
            break;

        case kCGPathElementAddLineToPoint: {
            CGPoint endPt = element->points[0];
            if (endPt.x < context->xMin) { context->xMin = endPt.x; context->yMin = endPt.y; }
            if (endPt.x > context->xMax) { context->xMax = endPt.x; context->yMax = endPt.y; }

            if ((context->x >= startPt.x && context->x <= endPt.x) ||
                (context->x >= endPt.x && context->x <= startPt.x)) {
                context->found = true;
                *context->resultY = linearInterpolationYForX(context->x, startPt, endPt);
            }
            startPt = endPt;
            break;
        }

        case kCGPathElementAddQuadCurveToPoint: {
            CGPoint ctrlPt = element->points[0];
            CGPoint endPt = element->points[1];
            if (endPt.x < context->xMin) { context->xMin = endPt.x; context->yMin = endPt.y; }
            if (endPt.x > context->xMax) { context->xMax = endPt.x; context->yMax = endPt.y; }

            if ((context->x >= startPt.x && context->x <= endPt.x) ||
                (context->x >= endPt.x && context->x <= startPt.x)) {
                context->found = true;
                *context->resultY = quadraticBezierYForX(context->x, startPt, ctrlPt, endPt);
            }
            startPt = endPt;
            break;
        }

        case kCGPathElementAddCurveToPoint: {
            CGPoint ctrlPt1 = element->points[0];
            CGPoint ctrlPt2 = element->points[1];
            CGPoint endPt = element->points[2];
            if (endPt.x < context->xMin) { context->xMin = endPt.x; context->yMin = endPt.y; }
            if (endPt.x > context->xMax) { context->xMax = endPt.x; context->yMax = endPt.y; }

            if ((context->x >= startPt.x && context->x <= endPt.x) ||
                (context->x >= endPt.x && context->x <= startPt.x)) {
                context->found = true;
                *context->resultY = bezierYForX(context->x, startPt, ctrlPt1, ctrlPt2, endPt);
            }
            startPt = endPt;
            break;
        }

        case kCGPathElementCloseSubpath:
            if (context->hasMoveTo) {
                *context->resultY = linearInterpolationYForX(context->x, startPt, context->firstPoint);
            }
            break;

        default:
            break;
    }
}

// 查找贝塞尔曲线上 x 对应的 y
+ (CGFloat)yValueForX:(CGFloat)x inBezierPath:(UIBezierPath *)path {
    __block CGFloat resultY = FLT_MAX;
    struct BezierSearchContext context = {x, &resultY, false, FLT_MAX, 0, -FLT_MAX, 0};
    CGPathApply(path.CGPath, &context, BezierPathApplierFunc);
    if (!context.found) {
        if (x <= context.xMin) return context.yMin;
        if (x >= context.xMax) return context.yMax;
        return (context.yMin + context.yMax) / 2.0; // 兜底策略
    }
    return resultY;
}

@end
