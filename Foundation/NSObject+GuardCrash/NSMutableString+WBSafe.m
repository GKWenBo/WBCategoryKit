//
//  NSMutableString+WBSafe.m
//  WBCategories
//
//  Created by wenbo on 2018/5/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "NSMutableString+WBSafe.h"
#import "NSObject+WBRuntime.h"

@implementation NSMutableString (WBSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(substringFromIndex:)
                                         swizzledSel:@selector(_wb_safe_MutableSubstringFromIndex:)
                                           selfClass:NSClassFromString(@"__NSCFString")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(substringToIndex:)
                                         swizzledSel:@selector(_wb_safe_MutableSubstringToIndex:) selfClass:NSClassFromString(@"__NSCFString")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(substringWithRange:)
                                         swizzledSel:@selector(_wb_safe_MutableSubstringWithRange:)
                                           selfClass:NSClassFromString(@"__NSCFString")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(rangeOfString:options:range:locale:)
                                         swizzledSel:@selector(_wb_safe_MutableRangeOfString:options:range:locale:)
                                           selfClass:NSClassFromString(@"__NSCFString")];
        [NSObject swizzleInstanceMethodWithOriginSel:@selector(appendString:)
                                         swizzledSel:@selector(_wb_safe_MutableAppendString:)
                                           selfClass:NSClassFromString(@"__NSCFString")];
    });
}

#pragma mark < Swizzle Method >
- (NSString *)_wb_safe_MutableSubstringFromIndex:(NSUInteger)from {
    if (from > self.length) {
        @try {
            return [self _wb_safe_MutableSubstringFromIndex:from];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }else {
        return [self _wb_safe_MutableSubstringFromIndex:from];
    }
}


- (NSString *)_wb_safe_MutableSubstringToIndex:(NSUInteger)to {
    if (to > self.length) {
        @try {
            return [self _wb_safe_MutableSubstringToIndex:to];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }else {
        return [self _wb_safe_MutableSubstringToIndex:to];
    }
}

- (NSString *)_wb_safe_MutableSubstringWithRange:(NSRange)range {
    if (range.location > self.length || range.length > self.length || (range.length + range.location) > self.length) {
        @try {
            return [self _wb_safe_MutableSubstringWithRange:range];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }else {
        return [self _wb_safe_MutableSubstringWithRange:range];
    }
}

- (NSRange)_wb_safe_MutableRangeOfString:(NSString *)searchString
                                 options:(NSStringCompareOptions)mask
                                   range:(NSRange)rangeOfReceiverToSearch
                                  locale:(nullable NSLocale *)locale {
    if (!searchString) {
        searchString = self;
    }
    if (rangeOfReceiverToSearch.location > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    if (rangeOfReceiverToSearch.length > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    if ((rangeOfReceiverToSearch.length + rangeOfReceiverToSearch.location) > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    return [self _wb_safe_MutableRangeOfString:searchString
                                       options:mask
                                         range:rangeOfReceiverToSearch
                                        locale:locale];
}

- (void)_wb_safe_MutableAppendString:(NSString *)aString {
    if (!aString) {
        @try {
            return [self _wb_safe_MutableAppendString:aString];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        } @finally {
            
        }
    }else {
       return [self _wb_safe_MutableAppendString:aString];
    }
}

@end
