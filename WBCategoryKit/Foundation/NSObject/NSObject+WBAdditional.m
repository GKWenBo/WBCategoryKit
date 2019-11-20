//
//  NSObject+WBAdditional.m
//  Pods
//
//  Created by 文波 on 2019/11/20.
//

#import "NSObject+WBAdditional.h"
#import <objc/runtime.h>
#import "NSObject+WBRuntime.h"

@implementation NSObject (WBAdditional)

- (void)wb_performSelector:(SEL)selector
  withPrimitiveReturnValue:(nullable void *)returnValue {
    [self wb_performSelector:selector
    withPrimitiveReturnValue:returnValue
                   arguments:nil];
}

- (void)wb_performSelector:(SEL)selector
  withPrimitiveReturnValue:(void *)returnValue
                 arguments:(void *)firstArgument, ... {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        va_list valist;
        va_start(valist, firstArgument);
        [invocation setArgument:firstArgument atIndex:2];// 0->self, 1->_cmd
        
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

- (nullable id)wb_valueForKey:(NSString *)key {
    if (@available(iOS 13.0, *)) {
        if ([self isKindOfClass:[UIView class]]) {
            NSThread.currentThread.wb_shouldIgnoreUIKVCAccessProhibited = YES;
            id value = [self valueForKey:key];
            NSThread.currentThread.wb_shouldIgnoreUIKVCAccessProhibited = NO;
            return value;
        }
    } else {
    }
    return [self valueForKey:key];
}


- (void)wb_setValue:(id)value forKey:(NSString *)key {
    if (@available(iOS 13.0, *)) {
        NSThread.currentThread.wb_shouldIgnoreUIKVCAccessProhibited = YES;
        [self setValue:value forKey:key];
        NSThread.currentThread.wb_shouldIgnoreUIKVCAccessProhibited = NO;
        return;
    } else {
    }
    [self setValue:value forKey:key];
}

@end

@implementation NSThread (WBKVC)

// MARK: getter && setter
- (void)setWb_shouldIgnoreUIKVCAccessProhibited:(BOOL)wb_shouldIgnoreUIKVCAccessProhibited {
    objc_setAssociatedObject(self, @selector(wb_shouldIgnoreUIKVCAccessProhibited), @(wb_shouldIgnoreUIKVCAccessProhibited), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wb_shouldIgnoreUIKVCAccessProhibited {
    return [objc_getAssociatedObject(self, @selector(wb_shouldIgnoreUIKVCAccessProhibited)) boolValue];
}

@end

@interface NSException (WBKVC)

@end

@implementation NSException (WBKVC)

+ (void)load {
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            WBOverrideImplementation(object_getClass([NSException class]), @selector(raise:format:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
               return ^(NSObject *selfObject, NSExceptionName raise, NSString *format, ...) {
                   if (raise == NSGenericException && [format isEqualToString:@"Access to %@'s %@ ivar is prohibited. This is an application bug"]) {
                       BOOL shouldIgnoreUIKVCAccessProhibited = NSThread.currentThread.wb_shouldIgnoreUIKVCAccessProhibited;
                       if (shouldIgnoreUIKVCAccessProhibited) return;
                       NSLog(@"%@", [NSString stringWithFormat:@"NSObject (QMUI), 使用 KVC 访问了 UIKit 的私有属性，会触发系统的 NSException，建议尽量避免此类操作，仍需访问可使用 BeginIgnoreUIKVCAccessProhibited 和 EndIgnoreUIKVCAccessProhibited 把相关代码包裹起来，或者直接使用 qmui_valueForKey: 、qmui_setValue:forKey:"]);
                   }
                   
                   id (*originSelectorIMP)(id, SEL, NSExceptionName name, NSString *, ...);
                   originSelectorIMP = (id (*)(id, SEL, NSExceptionName name, NSString *, ...))originalIMPProvider();
                   va_list args;
                   va_start(args, format);
                   NSString *reason =  [[NSString alloc] initWithFormat:format arguments:args];
                   originSelectorIMP(selfObject, originCMD, raise, reason);
                   va_end(args);
               };
            });
        });
    }
}

@end
