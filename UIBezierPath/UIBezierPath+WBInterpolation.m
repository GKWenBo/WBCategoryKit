//
//  UIBezierPath+WBInterpolation.m
//  WBCategoryKit
//
//  Created by 文波 on 2025/2/10.
//

#import "UIBezierPath+WBInterpolation.h"

@implementation UIBezierPath (WBInterpolation)

+ (UIBezierPath *)wb_interpolateCGPointsWithHermite:(NSArray *)pointsAsNSValues
                                             closed:(BOOL)closed {
    if ([pointsAsNSValues count] < 2)
        return nil;
    
    int nCurves = (int)(closed ? [pointsAsNSValues count] : [pointsAsNSValues count] - 1);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int ii=0; ii < nCurves; ++ii) {
        NSValue *value  = pointsAsNSValues[ii];
        
        CGPoint curPt, prevPt, nextPt, endPt;
        [value getValue:&curPt];
        if (ii==0)
            [path moveToPoint:curPt];
        
        int nextii = (ii+1) % [pointsAsNSValues count];
        int previi = (int)(ii-1 < 0 ? [pointsAsNSValues count] - 1 : ii - 1);
        
        [pointsAsNSValues[previi] getValue:&prevPt];
        [pointsAsNSValues[nextii] getValue:&nextPt];
        endPt = nextPt;
        
        float mx, my;
        if (closed || ii > 0) {
            mx = (nextPt.x - curPt.x) * 0.5 + (curPt.x - prevPt.x) * 0.5;
            my = (nextPt.y - curPt.y) * 0.5 + (curPt.y - prevPt.y) * 0.5;
        } else {
            mx = (nextPt.x - curPt.x) * 0.5;
            my = (nextPt.y - curPt.y) * 0.5;
        }
        
        CGPoint ctrlPt1;
        ctrlPt1.x = curPt.x + mx / 3.0;
        ctrlPt1.y = curPt.y + my / 3.0;
        
        [pointsAsNSValues[nextii] getValue:&curPt];
        
        nextii = (nextii+1)%[pointsAsNSValues count];
        previi = ii;
        
        [pointsAsNSValues[previi] getValue:&prevPt];
        [pointsAsNSValues[nextii] getValue:&nextPt];
        
        if (closed || ii < nCurves - 1) {
            mx = (nextPt.x - curPt.x) * 0.5 + (curPt.x - prevPt.x) * 0.5;
            my = (nextPt.y - curPt.y) * 0.5 + (curPt.y - prevPt.y) * 0.5;
        } else {
            mx = (curPt.x - prevPt.x) * 0.5;
            my = (curPt.y - prevPt.y) * 0.5;
        }
        
        CGPoint ctrlPt2;
        ctrlPt2.x = curPt.x - mx / 3.0;
        ctrlPt2.y = curPt.y - my / 3.0;
        
        if (curPt.y == prevPt.y || curPt.x == prevPt.x) { //横向或竖向绘制如果y或x相同，直接连直线
            [path addLineToPoint:endPt];
        } else {
            [path addCurveToPoint:endPt controlPoint1:ctrlPt1 controlPoint2:ctrlPt2];
        }
    }
    if (closed)
        [path closePath];
    return path;
    
}

@end
