//
//  NSCharacterSet+WBAdditional.h
//  Pods
//
//  Created by 文波 on 2019/12/8.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCharacterSet (WBAdditional)

/// 也即在系统的 URLQueryAllowedCharacterSet 基础上去掉“#&=”这3个字符，专用于 URL query 里来源于用户输入的 value，避免服务器解析出现异常。
@property (class, readonly, copy) NSCharacterSet *wb_URLUserInputQueryAllowedCharacterSet;

@end

NS_ASSUME_NONNULL_END
