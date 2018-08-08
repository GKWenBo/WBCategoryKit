//
//  NSArray+WBSafe.m
//  WBCategories
//
//  Created by wenbo on 2018/5/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "NSArray+WBSafe.h"
#import "NSObject+WBRuntime.h"

@implementation NSArray (WBSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(objectAtIndex:)
                                         swizzledSel:@selector(_wb_safe_ZeroObjectAtIndex:)
                                           selfClass:NSClassFromString(@"__NSArray0")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(objectAtIndex:)
                                         swizzledSel:@selector(_wb_safe_singleObjectAtIndex:)
                                           selfClass:NSClassFromString(@"__NSSingleObjectArrayI")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(objectAtIndex:)
                                         swizzledSel:@selector(_wb_safe_ObjectAtIndex:)
                                           selfClass:NSClassFromString(@"__NSArrayI")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(objectAtIndexedSubscript:)
                                         swizzledSel:@selector(_wb_safe_objectAtIndexedSubscript:)
                                           selfClass:NSClassFromString(@"__NSArrayI")];
    });
}


#pragma mark < Exchage Method >
- (id)_wb_safe_ZeroObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        @try {
            return [self _wb_safe_ZeroObjectAtIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }else {
        return [self _wb_safe_ZeroObjectAtIndex:index];
    }
}

- (id)_wb_safe_ObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        @try {
            return [self _wb_safe_ObjectAtIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }else {
        return [self _wb_safe_ObjectAtIndex:index];
    }
}

- (id)_wb_safe_singleObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        @try {
            return [self _wb_safe_singleObjectAtIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }else {
        return [self _wb_safe_singleObjectAtIndex:index];
    }
}

- (id)_wb_safe_objectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count) {
        @try {
            return [self _wb_safe_objectAtIndexedSubscript:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }else {
        return [self _wb_safe_objectAtIndexedSubscript:index];
    }
}

@end
