//
//  NSMutableArray+WBSafe.m
//  WBCategories
//
//  Created by wenbo on 2018/5/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "NSMutableArray+WBSafe.h"
#import "NSObject+WBRuntime.h"
@implementation NSMutableArray (WBSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(objectAtIndex:)
                                         swizzledSel:@selector(_wb_safe_MutableObjectAtIndex:)
                                           selfClass:NSClassFromString(@"__NSArrayM")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(removeObjectsInRange:)
                                         swizzledSel:@selector(_wb_safe_MutableRemoveObjectsInRange:)
                                           selfClass:NSClassFromString(@"__NSArrayM")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(insertObject:atIndex:)
                                         swizzledSel:@selector(_wb_safe_MutableInsertObject:atIndex:)
                                           selfClass:NSClassFromString(@"__NSArrayM")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(removeObject:inRange:)
                                         swizzledSel:@selector(_wb_safe_MutableRemoveObject:inRange:)
                                           selfClass:NSClassFromString(@"__NSArrayM")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(objectAtIndexedSubscript:)
                                         swizzledSel:@selector(_wb_safe_MutableObjectAtIndexedSubscript:)
                                           selfClass:NSClassFromString(@"__NSArrayM")];
    });
}

#pragma mark < Swizzle Method >
- (id)_wb_safe_MutableObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        @try {
            return [self _wb_safe_MutableObjectAtIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }else {
        return [self _wb_safe_MutableObjectAtIndex:index];
    }
}

- (void)_wb_safe_MutableRemoveObjectsInRange:(NSRange)range {
    if (range.location > self.count || range.length > self.count || (range.location + range.length) > self.count) {
        @try {
            return [self _wb_safe_MutableRemoveObjectsInRange:range];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        } @finally {
            
        }
    }else {
        return [self _wb_safe_MutableRemoveObjectsInRange:range];
    }
}

- (void)_wb_safe_MutableInsertObject:(id)object atIndex:(NSUInteger)index {
    if (index > self.count || !object) {
        @try {
            return [self _wb_safe_MutableInsertObject:object atIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        } @finally {
            
        }
    }else {
        return [self _wb_safe_MutableInsertObject:object atIndex:index];
    }
}

- (void)_wb_safe_MutableRemoveObject:(id)object inRange:(NSRange)range {
    if (range.location > self.count || range.length > self.count || (range.location + range.length) > self.count || !object) {
        @try {
            return [self _wb_safe_MutableRemoveObject:object inRange:range];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        } @finally {
            
        }
    }else {
        return [self _wb_safe_MutableRemoveObject:object inRange:range];
    }
}

- (id)_wb_safe_MutableObjectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count) {
        @try {
            return [self _wb_safe_MutableObjectAtIndexedSubscript:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }else {
        return [self _wb_safe_MutableObjectAtIndexedSubscript:index];
    }
}

@end
