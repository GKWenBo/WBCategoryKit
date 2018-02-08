//
//  UIFont+WBRuntimeSize.m
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIFont+WBRuntimeSize.h"
#import <objc/runtime.h>

@implementation UIFont (WBRuntimeSize)
+ (void)load {
    /**  获取替换后的方法  */
    Method newMethod = class_getClassMethod([self class], @selector(wb_adjustFont:));
    /**  获取替换前的类方法  */
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    /**  交换类方法  */
    method_exchangeImplementations(newMethod, method);
}

+ (UIFont *)wb_adjustFont:(CGFloat)fontSize {
    UIFont * newFont = nil;
    newFont = [UIFont wb_adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width /Screen_Width];
    return newFont;
    
}
@end
