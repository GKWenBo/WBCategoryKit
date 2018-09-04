//
//  UIScreen+WBFrame.m
//  WBCategories
//
//  Created by WMB on 2018/2/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIScreen+WBFrame.h"

/** << Exchage height and width > */
static inline CGSize wb_sizeSwap(CGSize size) {
    return CGSizeMake(size.height, size.width);
}

@implementation UIScreen (WBFrame)

+ (CGSize)wb_size {
    return [UIScreen mainScreen].bounds.size;
}

+ (CGFloat)wb_width {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)wb_height {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGSize)wb_orientationSize {
    CGFloat version = [[[UIDevice currentDevice] systemVersion] doubleValue];
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    return (version > 8.0  && isLandscape) ? wb_sizeSwap([UIScreen wb_size]) : [UIScreen wb_size];
}

+ (CGFloat)wb_orientationWidth {
    return [self wb_orientationSize].width;
}

+ (CGFloat)wb_orientationHeight {
    return [self wb_orientationSize].height;
}

+ (CGFloat)wb_brightness {
    return [UIScreen mainScreen].brightness;
}

+ (void)wb_setBrightness:(CGFloat)value {
    if (value > 1 || value < 0) return;
    [[UIScreen mainScreen] setBrightness:value];
}

+ (CGSize)wb_DPISize {
    CGSize size = [self wb_size];
    CGFloat scale = [[UIScreen mainScreen] scale];
    return CGSizeMake(size.width * scale, size.height  * scale);
}

@end
