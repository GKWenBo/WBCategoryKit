//
//  WBHelper.h
//  Pods
//
//  Created by WenBo on 2019/11/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBHelper : NSObject


@end

@interface WBHelper (UIGraphic)

/// context是否合法
+ (void)wb_inspectContextIfInvalidatedInDebugMode:(CGContextRef)context;
+ (BOOL)wb_inspectContextIfInvalidatedInReleaseMode:(CGContextRef)context;

@end

NS_ASSUME_NONNULL_END
