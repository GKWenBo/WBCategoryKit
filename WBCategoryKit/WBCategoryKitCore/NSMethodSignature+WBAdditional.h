//
//  NSMethodSignature+WBAdditional.h
//  Pods
//
//  Created by 文波 on 2019/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMethodSignature (WBAdditional)

/// 以 NSString 格式返回当前 NSMethodSignature 的 typeEncoding，例如 v@:
@property(nullable, nonatomic, copy, readonly) NSString *wb_typeString;

/// 以 const char 格式返回当前 NSMethodSignature 的 typeEncoding，例如 v@:
@property(nullable, nonatomic, readonly) const char *wb_typeEncoding;

@end

NS_ASSUME_NONNULL_END
