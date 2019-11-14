//
//  NSObject+WBRuntime.h
//  Pods
//
//  Created by 文波 on 2019/11/14.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/// 以高级语言的方式描述一个 objc_property_t 的各种属性，请使用 `+descriptorWithProperty` 生成对象后直接读取对象的各种值。

@interface WBUIPropertyDescriptor : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) SEL getter;
@property(nonatomic, assign) SEL setter;

@property(nonatomic, assign) BOOL isAtomic;
@property(nonatomic, assign) BOOL isNonatomic;

@property(nonatomic, assign) BOOL isAssign;
@property(nonatomic, assign) BOOL isWeak;
@property(nonatomic, assign) BOOL isStrong;
@property(nonatomic, assign) BOOL isCopy;

@property(nonatomic, assign) BOOL isReadonly;
@property(nonatomic, assign) BOOL isReadwrite;

@property(nonatomic, copy) NSString *type;

+ (instancetype)descriptorWithProperty:(objc_property_t)property;

@end

// MARK: -------- CG_INLINE函数
CG_INLINE BOOL WBHasOverrideSuperclassMethod(Class targetClass, SEL targetSelector) {
    Method method = class_getInstanceMethod(targetClass, targetSelector);
    if (!method) return NO;
    
    Method methodOfSuperClass = class_getInstanceMethod(class_getSuperclass(targetClass), targetSelector);
    if (!methodOfSuperClass) return YES;
    
    return method != methodOfSuperClass;
}

/**
*  如果 fromClass 里存在 originSelector，则这个函数会将 fromClass 里的 originSelector 与 toClass 里的 newSelector 交换实现。
*  如果 fromClass 里不存在 originSelecotr，则这个函数会为 fromClass 增加方法 originSelector，并且该方法会使用 toClass 的 newSelector 方法的实现，而 toClass 的 newSelector 方法的实现则会被替换为空内容
*  @warning 注意如果 fromClass 里的 originSelector 是继承自父类并且 fromClass 也没有重写这个方法，这会导致实际上被替换的是父类，然后父类及父类的所有子类（也即 fromClass 的兄弟类）也受影响，因此使用时请谨记这一点。因此建议使用 OverrideImplementation 系列的方法去替换，尽量避免使用 ExchangeImplementations。
*  @param _fromClass 要被替换的 class，不能为空
*  @param _originSelector 要被替换的 class 的 selector，可为空，为空则相当于为 fromClass 新增这个方法
*  @param _toClass 要拿这个 class 的方法来替换
*  @param _newSelector 要拿 toClass 里的这个方法来替换 originSelector
*  @return 是否成功替换（或增加）
*/
CG_INLINE BOOL
WBExchangeImplementationsInTwoClasses(Class _fromClass, SEL _originSelector, Class _toClass, SEL _newSelector) {
    if (!_fromClass || !_toClass) return NO;
 
    Method oriMethod = class_getInstanceMethod(_fromClass, _originSelector);
    Method newMethod = class_getInstanceMethod(_toClass, _newSelector);
    
    if (!newMethod) return NO;
    
    BOOL isAddedMethod = class_addMethod(_fromClass, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        // 如果 class_addMethod 成功了，说明之前 fromClass 里并不存在 originSelector，所以要用一个空的方法代替它，以避免 class_replaceMethod 后，后续 toClass 的这个方法被调用时可能会 crash
        IMP oriMethodIMP = method_getImplementation(oriMethod) ?: imp_implementationWithBlock(^(id selfObject) {});
        const char *oriMethodTypeEncoding = method_getTypeEncoding(oriMethod) ?: "v@:";
        class_replaceMethod(_toClass, _newSelector, oriMethodIMP, oriMethodTypeEncoding);
    }else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
    return YES;
}

/// 交换同一个 class 里的 originSelector 和 newSelector 的实现，如果原本不存在 originSelector，则相当于给 class 新增一个叫做 originSelector 的方法
CG_INLINE BOOL WBExchangeImplementations(Class _class, SEL _originSelector, SEL _newSelector) {
    return WBExchangeImplementationsInTwoClasses(_class, _originSelector, _class, _newSelector);
}


@interface NSObject (WBRuntime)

/**
 Exchange method.
 
 @param oriSel origin method.
 @param newSel new method.
 */
+ (void)wb_exchangeMethodWithOriginMethod:(SEL)oriSel
                                   newSel:(SEL)newSel;

/**
 swizzle 类方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 @param selfClass 要swizzle的Class
 */
+ (void)swizzleClassMethodWithOriginSel:(SEL)oriSel
                            swizzledSel:(SEL)swiSel
                              selfClass:(Class)selfClass;

/**
 swizzle 实例方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 @param selfClass 要swizzle的Class
 */
+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel
                               swizzledSel:(SEL)swiSel
                                 selfClass:(Class)selfClass;

/**
 判断方法是否在子类里override了
 
 @param cls 传入要判断的Class
 @param sel 传入要判断的Selector
 @return 返回判断是否被重载的结果
 */
- (BOOL)isMethodOverride:(Class)cls
                selector:(SEL)sel;

/**
 判断当前类是否在主bundle里
 
 @param cls 出入类
 @return 返回判断结果
 */
+ (BOOL)isMainBundleClass:(Class)cls;

/**
 动态创建绑定selector的类
 tip：每当无法找到selectorcrash转发过来的所有selector都会追加到当前Class上
 
 @param aSelector 传入selector
 @return 返回创建的类
 */
+ (Class)addMethodToStubClass:(SEL)aSelector;

@end

NS_ASSUME_NONNULL_END
