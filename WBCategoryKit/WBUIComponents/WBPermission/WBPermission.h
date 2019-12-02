//
//  WBPermission.h
//  Pods-WBCategoryKit_Example
//
//  Created by WenBo on 2019/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WBPermissionDelegate <NSObject>

/// 是否授权
+ (BOOL)wb_authorized;

/// 授权状态
+ (NSInteger)wb_authorizationStatus;

/// 授权状态回调
/// @param completion 授权状态回调
+ (void)wb_authorizeWithCompletion:(void (^)(BOOL granted, BOOLfirstTime))completion;

@end

@interface WBPermission : NSObject

@end

NS_ASSUME_NONNULL_END
