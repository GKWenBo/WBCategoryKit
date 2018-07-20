//
//  NSDictionary+WBSafe.m
//  WBCategories
//
//  Created by wenbo on 2018/5/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "NSDictionary+WBSafe.h"
#import "NSObject+WBRuntime.h"

@implementation NSDictionary (WBSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(initWithObjects:forKeys:count:)
                                         swizzledSel:@selector(_wb_safe_initWithObjects:forKeys:count:)
                                           selfClass:NSClassFromString(@"__NSPlaceholderDictionary")];
    });
}

#pragma mark < Swizzle Method >
- (instancetype)_wb_safe_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < cnt; i ++) {
        if (!keys[i] && objects[i]) {
            break;
        }else {
            rightCount ++;
        }
    }
    return [self _wb_safe_initWithObjects:objects
                                  forKeys:keys
                                    count:rightCount];
}

@end
