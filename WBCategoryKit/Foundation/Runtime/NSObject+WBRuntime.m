//
//  NSObject+WBRuntime.m
//  Pods
//
//  Created by 文波 on 2019/11/14.
//

#import "NSObject+WBRuntime.h"
#import "WBMacroDefinition.h"

char * const kProtectCrashProtectorName = "kProtectCrashProtector";
void ProtectCrashProtected(id self, SEL sel) {}

@implementation WBUIPropertyDescriptor

+ (instancetype)descriptorWithProperty:(objc_property_t)property {
    WBUIPropertyDescriptor *descriptor = [[WBUIPropertyDescriptor alloc] init];
    NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
    descriptor.name = propertyName;
    
    // getter
    char *getterChar = property_copyAttributeValue(property, "G");
    descriptor.getter = NSSelectorFromString(getterChar != NULL ? [NSString stringWithUTF8String:getterChar] : propertyName);
    if (getterChar != NULL) {
        free(getterChar);
    }
    
    // setter
    char *setterChar = property_copyAttributeValue(property, "S");
    NSString *setterString = setterChar != NULL ? [NSString stringWithUTF8String:setterChar] : NSStringFromSelector(wb_setterWithGetter(NSSelectorFromString(propertyName)));
    descriptor.setter = NSSelectorFromString(setterString);
    if (setterChar != NULL) {
        free(setterChar);
    }
    
    // atomic/nonatomic
    char *attrValue_N = property_copyAttributeValue(property, "N");
    BOOL isAtomic = (attrValue_N == NULL);
    descriptor.isAtomic = isAtomic;
    descriptor.isNonatomic = !isAtomic;
    if (attrValue_N != NULL) {
        free(attrValue_N);
    }
    
    // assign/weak/strong/copy
    char *attrValue_isCopy = property_copyAttributeValue(property, "C");
    char *attrValue_isStrong = property_copyAttributeValue(property, "&");
    char *attrValue_isWeak = property_copyAttributeValue(property, "W");
    BOOL isCopy = attrValue_isCopy != NULL;
    BOOL isStrong = attrValue_isStrong != NULL;
    BOOL isWeak = attrValue_isWeak != NULL;
    if (attrValue_isCopy != NULL) {
        free(attrValue_isCopy);
    }
    if (attrValue_isStrong != NULL) {
        free(attrValue_isStrong);
    }
    if (attrValue_isWeak != NULL) {
        free(attrValue_isWeak);
    }
    descriptor.isCopy = isCopy;
    descriptor.isStrong = isStrong;
    descriptor.isWeak = isWeak;
    descriptor.isAssign = !isCopy && !isStrong && !isWeak;
    
    // readonly/readwrite
    char *attrValue_isReadonly = property_copyAttributeValue(property, "R");
    BOOL isReadonly = (attrValue_isReadonly != NULL);
    if (attrValue_isReadonly != NULL) {
        free(attrValue_isReadonly);
    }
    descriptor.isReadonly = isReadonly;
    descriptor.isReadwrite = !isReadonly;
    
    // type
    char *type = property_copyAttributeValue(property, "T");
    descriptor.type = [WBUIPropertyDescriptor wb_typeWithEncodeString:[NSString stringWithUTF8String:type]];
    if (type != NULL) {
        free(type);
    }
    
    return descriptor;
}

- (NSString *)description {
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:@"@property("];
    if (self.isNonatomic) [result appendString:@"nonatomic, "];
    [result appendString:self.isAssign ? @"assign" : (self.isWeak ? @"weak" : (self.isStrong ? @"strong" : @"copy"))];
    if (self.isReadonly) [result appendString:@", readonly"];
    if (![NSStringFromSelector(self.getter) isEqualToString:self.name]) [result appendFormat:@", getter=%@", NSStringFromSelector(self.getter)];
    if (self.setter != wb_setterWithGetter(NSSelectorFromString(self.name))) [result appendFormat:@", setter=%@", NSStringFromSelector(self.setter)];
    [result appendString:@") "];
    [result appendString:self.type];
    [result appendString:@" "];
    [result appendString:self.name];
    [result appendString:@";"];
    return result.copy;
}

#define _WBDetectTypeAndReturn(_type) if (strncmp(@encode(_type), typeEncoding, strlen(@encode(_type))) == 0) return @#_type;

+ (NSString *)wb_typeWithEncodeString:(NSString *)encodeString {
    if ([encodeString containsString:@"@\""]) {
        NSString *result = [encodeString substringWithRange:NSMakeRange(2, encodeString.length - 2 - 1)];
        if ([result containsString:@"<"] && [result containsString:@">"]) {
            // protocol
            if ([result hasPrefix:@"<"]) {
                // id pointer
                return [NSString stringWithFormat:@"id%@", result];
            }
        }
        // class
        return [NSString stringWithFormat:@"%@ *", result];
    }
    
    const char *typeEncoding = encodeString.UTF8String;
    _WBDetectTypeAndReturn(NSInteger)
    _WBDetectTypeAndReturn(NSUInteger)
    _WBDetectTypeAndReturn(int)
    _WBDetectTypeAndReturn(short)
    _WBDetectTypeAndReturn(long)
    _WBDetectTypeAndReturn(long long)
    _WBDetectTypeAndReturn(char)
    _WBDetectTypeAndReturn(unsigned char)
    _WBDetectTypeAndReturn(unsigned int)
    _WBDetectTypeAndReturn(unsigned short)
    _WBDetectTypeAndReturn(unsigned long)
    _WBDetectTypeAndReturn(unsigned long long)
    _WBDetectTypeAndReturn(CGFloat)
    _WBDetectTypeAndReturn(float)
    _WBDetectTypeAndReturn(double)
    _WBDetectTypeAndReturn(void)
    _WBDetectTypeAndReturn(char *)
    _WBDetectTypeAndReturn(id)
    _WBDetectTypeAndReturn(Class)
    _WBDetectTypeAndReturn(SEL)
    _WBDetectTypeAndReturn(BOOL)
    
    return encodeString;
}

@end

@implementation NSObject (WBRuntime)

+ (void)wb_exchangeMethodWithOriginMethod:(SEL)oriSel
                                   newSel:(SEL)newSel {
    /**  获取替换后的方法  */
    Method method = class_getClassMethod([self class], oriSel);
    /**  获取替换前的类方法  */
    Method newMethod = class_getClassMethod([self class], newSel);
    /**  交换类方法  */
    method_exchangeImplementations(method, newMethod);
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
