//
//  WBHelper.m
//  Pods
//
//  Created by WenBo on 2019/11/13.
//

#import "WBHelper.h"

@implementation WBHelper

@end

@implementation WBHelper (UIGraphic)

static CGFloat wb_pixelOne = -1.0f;
/// 获取一像素的大小
+ (CGFloat)wb_pixelOne {
    if (wb_pixelOne < 0) {
        wb_pixelOne = 1 / [[UIScreen mainScreen] scale];
    }
    return wb_pixelOne;
}

+ (void)wb_inspectContextIfInvalidatedInDebugMode:(CGContextRef)context {
    if (!context) {
        // crash了就找zhoon或者molice
        NSAssert(NO, @"QMUI CGPostError, %@:%d %s, 非法的context：%@\n%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, context, [NSThread callStackSymbols]);
    }
}

+ (BOOL)wb_inspectContextIfInvalidatedInReleaseMode:(CGContextRef)context {
    if (context) {
        return YES;
    }
    return NO;
}

@end
