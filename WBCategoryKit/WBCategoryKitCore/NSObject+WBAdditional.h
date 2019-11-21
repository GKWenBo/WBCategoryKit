//
//  NSObject+WBAdditional.h
//  Pods
//
//  Created by 文波 on 2019/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WBAdditional)


/// 调用一个无参数、返回值类型为非对象的 selector。如果返回值类型为对象，请直接使用系统的 performSelector: 方法。
/// @param selector 要被调用的方法名
/// @param returnValue  selector 的返回值的指针地址，请先定义一个变量再将其指针地址传进来，例如 &result
- (void)wb_performSelector:(SEL)selector
  withPrimitiveReturnValue:(nullable void *)returnValue;

/// 调用一个返回值类型为非对象且带参数的 selector，参数类型支持对象和非对象，也没有数量限制。
/// @param selector 要被调用的方法名
/// @param returnValue selector 的返回值的指针地址
/// @param firstArgument 参数列表，请传参数的指针地址，支持多个参数
/// @code
/// CGPoint point = xxx;
/// UIEvent *event = xxx;
/// BOOL isInside;
/// [view qmui_performSelector:@selector(pointInside:withEvent:) withPrimitiveReturnValue:&isInside arguments:&point, &event, nil];
- (void)wb_performSelector:(SEL)selector
  withPrimitiveReturnValue:(void *)returnValue
                 arguments:(nullable void *)firstArgument, ...;

/**
 iOS 13 下系统禁止通过 KVC 访问私有 API，因此提供这种方式在遇到 access prohibited 的异常时可以取代 valueForKey: 使用。
 
 对 iOS 12 及以下的版本，等价于 valueForKey:。
 
 @note QMUI 提供2种方式兼容系统的 access prohibited 异常：
 1. 通过将配置表的 IgnoreKVCAccessProhibited 置为 YES 来全局屏蔽系统的异常警告，代码中依然正常使用系统的 valueForKey:、setValue:forKey:，当开启后再遇到 access prohibited 异常时，将会用 QMUIWarnLog 来提醒，不再中断 App 的运行，这是首选推荐方案。
 2. 使用 qmui_valueForKey:、qmui_setValue:forKey: 代替系统的 valueForKey:、setValue:forKey:，适用于不希望全局屏蔽，只针对某个局部代码自己处理的场景。
 
 @link https://github.com/Tencent/QMUI_iOS/issues/617
 
 @param key ivar 属性名，支持下划线或不带下划线
 @return key 对应的 value，如果该 key 原本是非对象的值，会被用 NSNumber、NSValue 包裹后返回
 */
- (nullable id)wb_valueForKey:(NSString *)key;

/**
 iOS 13 下系统禁止通过 KVC 访问私有 API，因此提供这种方式在遇到 access prohibited 的异常时可以取代 setValue:forKey: 使用。
 
 对 iOS 12 及以下的版本，等价于 setValue:forKey:。
 
 @note QMUI 提供2种方式兼容系统的 access prohibited 异常：
 1. 通过将配置表的 IgnoreKVCAccessProhibited 置为 YES 来全局屏蔽系统的异常警告，代码中依然正常使用系统的 valueForKey:、setValue:forKey:，当开启后再遇到 access prohibited 异常时，将会用 QMUIWarnLog 来提醒，不再中断 App 的运行，这是首选推荐方案。
 2. 使用 qmui_valueForKey:、qmui_setValue:forKey: 代替系统的 valueForKey:、setValue:forKey:，适用于不希望全局屏蔽，只针对某个局部代码自己处理的场景。
 
 @link https://github.com/Tencent/QMUI_iOS/issues/617
 
 @param key ivar 属性名，支持下划线或不带下划线
 @return key 对应的 value，如果该 key 原本是非对象的值，会被用 NSNumber、NSValue 包裹后返回
 */
- (void)wb_setValue:(nullable id)value forKey:(NSString *)key;

@end

@interface NSThread (WBKVC)

/// 是否将当前线程标记为忽略系统的 KVC access prohibited 警告，默认为 NO，当开启后，NSException 将不会再抛出 access prohibited 异常
/// @see BeginIgnoreUIKVCAccessProhibited、EndIgnoreUIKVCAccessProhibited
@property(nonatomic, assign) BOOL wb_shouldIgnoreUIKVCAccessProhibited;

@end

NS_ASSUME_NONNULL_END
