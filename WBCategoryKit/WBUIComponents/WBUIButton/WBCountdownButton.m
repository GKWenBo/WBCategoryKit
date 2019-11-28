//
//  WBCountdownButton.m
//  Pods
//
//  Created by WenBo on 2019/11/28.
//

#import "WBCountdownButton.h"

// MARK: -------- Category
@interface NSTimer (WBCountdownBlocksSupport)

+ (NSTimer *)wbcd_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                           block:(void(^)(void))block
                                         repeats:(BOOL)repeats;

@end

@implementation NSTimer (WBCountdownBlocksSupport)

+ (NSTimer *)wbcd_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                           block:(void (^)(void))block
                                         repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(wbcd_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)wbcd_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if(block) {
        block();
    }
}

@end

@interface WBCountdownButton () {
    NSInteger _second;
    NSUInteger _totalSecond;
    
    NSTimer *_timer;
    NSDate *_startDate;
    
    WBCountdownChanging _countdownChanging;
    WBCountdownFinished _countdownFinished;
    WBTouchedCountdownButtonHandler _touchedCountdownButtonHandler;
}

@end

@implementation WBCountdownButton

- (void)wb_countdownButtonHandler:(WBTouchedCountdownButtonHandler)touchedCountdownButtonHandler {
    _touchedCountdownButtonHandler = [touchedCountdownButtonHandler copy];
    
    [self addTarget:self
             action:@selector(touched:)
   forControlEvents:UIControlEventTouchUpInside];
}

- (void)touched:(WBCountdownButton *)sender {
    if (_touchedCountdownButtonHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_touchedCountdownButtonHandler(sender, sender.tag);
        });
    }
}

- (void)wb_countdownChanging:(WBCountdownChanging)countdownChanging {
    _countdownChanging = [countdownChanging copy];
}

- (void)wb_countdownFinished:(WBCountdownFinished)countdownFinished {
    _countdownFinished = [countdownFinished copy];
}

- (void)wb_startcountdownWithSecond:(NSUInteger)second {
    _totalSecond = second;
     _second = second;
    
     __weak typeof(self) weakSelf = self;
     _timer = [NSTimer wbcd_scheduledTimerWithTimeInterval:1.0
                                                     block:^{
         typeof(weakSelf) strongSelf = weakSelf;
         [strongSelf timerStart];
     } repeats:YES];
     
     _startDate = [NSDate date];
     _timer.fireDate = [NSDate distantPast];
     [[NSRunLoop currentRunLoop]addTimer:_timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)timerStart {
     double deltaTime = [[NSDate date] timeIntervalSinceDate:_startDate];
    
     _second = _totalSecond - (NSInteger)(deltaTime + 0.5) ;

    if (_second< 0.0)
    {
        [self wb_stopCountdown];
    }
    else
    {
        if (_countdownChanging)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = self -> _countdownChanging(self, self -> _second);
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitle:title forState:UIControlStateDisabled];
            });
        }
        else
        {
            NSString *title = [NSString stringWithFormat:@"%zd秒",_second];
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];

        }
    }
}

- (void)wb_stopCountdown {
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)])
        {
            if ([_timer isValid])
            {
                [_timer invalidate];
                _second = _totalSecond;
                if (_countdownFinished)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *title = self -> _countdownFinished(self, self -> _totalSecond);
                        [self setTitle:title forState:UIControlStateNormal];
                        [self setTitle:title forState:UIControlStateDisabled];
                    });
                }
                else
                {
                    [self setTitle:@"重新获取" forState:UIControlStateNormal];
                    [self setTitle:@"重新获取" forState:UIControlStateDisabled];
                }
            }
        }
    }
}

@end
