//
//  NSObject+WBRuntime.m
//  UINavigationItemDemo
//
//  Created by WMB on 2017/9/26.
//  Copyright © 2017年 WMB. All rights reserved.
//

#import "NSObject+WBRuntime.h"

char * const kProtectCrashProtectorName = "kProtectCrashProtector";
void ProtectCrashProtected(id self, SEL sel) {
}

@implementation NSObject (WBRuntime)

+ (void)wb_exchangeMethodWithOriginMethod:(SEL)oriSel
                                   newSel:(SEL)newSel {
    /**  获取替换后的方法  */
    Method newMethod = class_getClassMethod([self class], oriSel);
    /**  获取替换前的类方法  */
    Method method = class_getClassMethod([self class], newSel);
    /**  交换类方法  */
    method_exchangeImplementations(newMethod, method);
}

+ (void)swizzleClassMethodWithOriginSel:(SEL)oriSel
                            swizzledSel:(SEL)swiSel
                              selfClass:(Class)selfClass {
    Method originAddObserverMethod = class_getClassMethod(selfClass, oriSel);
    Method swizzledAddObserverMethod = class_getClassMethod(selfClass, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel
                           oriMethod:originAddObserverMethod
                         swizzledSel:swiSel
                      swizzledMethod:swizzledAddObserverMethod
                               class:selfClass];
}

+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel
                               swizzledSel:(SEL)swiSel
                                 selfClass:(Class)selfClass {
    Method originAddObserverMethod = class_getInstanceMethod(selfClass, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(selfClass, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel
                           oriMethod:originAddObserverMethod
                         swizzledSel:swiSel
                      swizzledMethod:swizzledAddObserverMethod
                               class:selfClass];
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

+ (Class)addMethodToStubClass:(SEL)aSelector {
    Class ProtectCrashProtector = objc_getClass(kProtectCrashProtectorName);
    
    if (!ProtectCrashProtector) {
        ProtectCrashProtector = objc_allocateClassPair([NSObject class], kProtectCrashProtectorName, sizeof([NSObject class]));
        objc_registerClassPair(ProtectCrashProtector);
    }
    
    class_addMethod(ProtectCrashProtector, aSelector, (IMP)ProtectCrashProtected, "v@:");
    return ProtectCrashProtector;
}

- (BOOL)isMethodOverride:(Class)cls selector:(SEL)sel {
    IMP clsIMP = class_getMethodImplementation(cls, sel);
    IMP superClsIMP = class_getMethodImplementation([cls superclass], sel);
    
    return clsIMP != superClsIMP;
}

+ (BOOL)isMainBundleClass:(Class)cls {
    return cls && [[NSBundle bundleForClass:cls] isEqual:[NSBundle mainBundle]];
}

@end
