//
//  WBCountdownTool.h
//  WBCountdownToolDemo
//
//  Created by Mr_Lucky on 2018/10/16.
//  Copyright © 2018 wenbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define WB_CountdownManager [WBCountdownManager shareManager]

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const WBCountdownChangeNotificatonName;

@interface WBCountdownManager : NSObject

/// 单例
+ (instancetype)shareManager;

/// 开始倒计时
- (void)startCountdownTimer;

/// 销毁定时器 
- (void)destroyCountdownTimer;

/// 如果只需要一个倒计时差, 可继续使用timeInterval属性
/// 增加后台模式, 后台状态下会继续计算时间差
@property (nonatomic, assign) BOOL backgroudRecord;

/// 时间差(单位:秒)
@property (nonatomic, assign) NSInteger timeinterval;

/// 刷新倒计时
- (void)refreshCountdownTime;

/// 添加倒计时源
/// @param identifier 倒计时标识
- (void)addSourceTimerWithIdentifier:(NSString *)identifier;

/// 获取时间差
/// @param identifier 倒计时标识
- (NSInteger)countdownTimeWithIdentifier:(NSString *)identifier;

/// 刷新倒计时源
/// @param identifier 倒计时标识
- (void)refreshSourceTimerWithIdentifier:(NSString *)identifier;

/// 刷新所有计时源
- (void)reloadAllSourceTimer;

/// 清除倒计时源
/// @param identifier 倒计时标识
- (void)removeSourceTimerWithIdentifier:(NSString *)identifier;

/// 清除所有倒计时源
- (void)removeAllSourceTimer;

@end

@interface WBCountdownModel : NSObject

@property (nonatomic, assign) NSTimeInterval timeInterval;

+ (instancetype)countdownModelWithTimeInterval:(NSInteger)timeinterval;

@end

NS_ASSUME_NONNULL_END
