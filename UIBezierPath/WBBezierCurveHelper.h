//
//  WBBezierCurveHelper.h
//  Pods
//
//  Created by wenbo22 on 2025/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBBezierCurveHelper : NSObject

+ (CGFloat)yValueForX:(CGFloat)x inBezierPath:(UIBezierPath *)path;

@end

NS_ASSUME_NONNULL_END
