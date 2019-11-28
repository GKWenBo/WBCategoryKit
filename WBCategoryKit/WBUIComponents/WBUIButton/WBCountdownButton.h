//
//  WBCountdownButton.h
//  Pods
//
//  Created by WenBo on 2019/11/28.
//

#import <UIKit/UIKit.h>
@class WBCountdownButton;

NS_ASSUME_NONNULL_BEGIN
///倒计时改变回调block
typedef NSString *_Nullable(^WBCountdownChanging)(WBCountdownButton *countdownButton, NSUInteger second);
///倒计时结束block
typedef NSString *_Nullable(^WBCountdownFinished)(WBCountdownButton *countdownButton, NSUInteger second);
typedef void (^WBTouchedCountdownButtonHandler)(WBCountdownButton *countdownButton, NSInteger tag);

@interface WBCountdownButton : UIButton

/// 绑定用户信息
@property(nonatomic, strong) id userInfo;

/// 倒计时按钮点击回调
/// @param touchedCountdownButtonHandler touch回调
- (void)wb_countdownButtonHandler:(WBTouchedCountdownButtonHandler)touchedCountdownButtonHandler;

/// 倒计时时间改变回调
/// @param countdownChanging 倒计时改变回调
- (void)wb_countdownChanging:(WBCountdownChanging)countdownChanging;

/// 倒计时结束回调
/// @param countdownFinished 结束回调
- (void)wb_countdownFinished:(WBCountdownFinished)countdownFinished;

/// 开始倒计时
/// @param second 倒计时秒数
- (void)wb_startcountdownWithSecond:(NSUInteger)second;

///停止倒计时
- (void)wb_stopCountdown;

@end

NS_ASSUME_NONNULL_END
