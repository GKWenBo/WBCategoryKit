//
//  NSMutableDictionary+WBSafe.m
//  WBCategories
//
//  Created by wenbo on 2018/5/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "NSMutableDictionary+WBSafe.h"
#import "NSObject+WBRuntime.h"

@implementation NSMutableDictionary (WBSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(removeObjectForKey:)
                                         swizzledSel:@selector(_wb_safe_MutableRemoveObjectForKey:)
                                           selfClass:NSClassFromString(@"__NSDictionaryM")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(setObject:forKey:)
                                         swizzledSel:@selector(_wb_safe_MutableSetObject:forKey:) selfClass:NSClassFromString(@"__NSDictionaryM")];
    });
}

#pragma mark < Swizzle Method >
- (void)_wb_safe_MutableRemoveObjectForKey:(id<NSCopying>)akey {
    if (!akey) {
        @try {
            return [self _wb_safe_MutableRemoveObjectForKey:akey];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        } @finally {
            
        }
    }else {
        return [self _wb_safe_MutableRemoveObjectForKey:akey];
    }
}

- (void)_wb_safe_MutableSetObject:(id)anObject forKey:(id<NSCopying>)akey {
    if (!anObject || !akey) {
        @try {
            return [self _wb_safe_MutableSetObject:anObject forKey:akey];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        } @finally {
            
        }
    }else {
        return [self _wb_safe_MutableSetObject:anObject forKey:akey];
    }
}

@end
