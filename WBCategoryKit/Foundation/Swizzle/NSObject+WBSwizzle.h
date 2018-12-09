//
//  NSObject+WBSwizzle.h
//  Pods-WBCategoryKit_Example
//
//  Created by Mr_Lucky on 2018/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WBSwizzle)

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
