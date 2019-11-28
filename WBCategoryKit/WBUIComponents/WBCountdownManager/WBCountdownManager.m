//
//  WBCountdownTool.m
//  WBCountdownToolDemo
//
//  Created by Mr_Lucky on 2018/10/16.
//  Copyright © 2018 wenbo. All rights reserved.
//

#import "WBCountdownManager.h"

NSString *const WBCountdownChangeNotificatonName = @"kWBCountdownChangeNotificatonName";;

@interface WBCountdownManager ()

@property (nonatomic, strong) NSTimer *timer;
/*  < 时间差字典(单位:秒)(使用字典来存放, 支持多列表或多页面使用) > */
@property (nonatomic, strong) NSMutableDictionary<NSString *, WBCountdownModel *> *timeIntervalDict;
@property (nonatomic, assign) CFAbsoluteTime lastTime;

@end

static WBCountdownManager *_tool = nil;
@implementation WBCountdownManager

- (void)dealloc {
    [self removeNoti];
}

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[self alloc]init];
    });
    return _tool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addNoti];
    }
    return self;
}

- (void)addNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wb_enterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wb_didEnterBackground) name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)removeNoti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK:通知
- (void)wb_enterForeground {
    if (self.backgroudRecord) {
        CFAbsoluteTime timeInterval = CFAbsoluteTimeGetCurrent() - self.lastTime;
        [self timerActionWithTimeInterval:(NSInteger)timeInterval];
        [self startCountdownTimer];
    }
}

- (void)wb_didEnterBackground {
    self.backgroudRecord = (self.timer != nil);
    if (self.backgroudRecord) {
        self.lastTime = CFAbsoluteTimeGetCurrent();
        [self destroyCountdownTimer];
    }
}


// MARK:Public Method
- (void)startCountdownTimer {
    [self timer];
}

- (void)refreshCountdownTime {
    /*  < 刷新只要让时间差为0即可 > */
    _timeinterval = 0;
}

- (void)destroyCountdownTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

// MARK:定时器
- (void)wb_refreshCountdownTime {
    [self timerActionWithTimeInterval:1];
}

- (void)timerActionWithTimeInterval:(NSInteger)timeInterval {
    /*  <  时间差+ > */
    self.timeinterval += timeInterval;
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, WBCountdownModel * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval += timeInterval;
    }];
    
    /*  < 发出通知 > */
    [[NSNotificationCenter defaultCenter] postNotificationName:WBCountdownChangeNotificatonName
                                                        object:nil];
}

- (void)addSourceTimerWithIdentifier:(NSString *)identifier {
    WBCountdownModel *model = self.timeIntervalDict[identifier];
    if (model) {
        model.timeInterval = 0;
    }else {
        [self.timeIntervalDict setObject:[WBCountdownModel countdownModelWithTimeInterval:0]
                                  forKey:identifier];
    }
}

- (NSInteger)countdownTimeWithIdentifier:(NSString *)identifier {
    return self.timeIntervalDict[identifier].timeInterval;
}

- (void)refreshSourceTimerWithIdentifier:(NSString *)identifier {
    self.timeIntervalDict[identifier].timeInterval = 0;
}

- (void)reloadAllSourceTimer {
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, WBCountdownModel * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval = 0;
    }];
}

- (void)removeSourceTimerWithIdentifier:(NSString *)identifier {
    [self.timeIntervalDict removeObjectForKey:identifier];
}

- (void)removeAllSourceTimer {
    [self.timeIntervalDict removeAllObjects];
}

// MARK:setter && getter
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                  target:self
                                                selector:@selector(wb_refreshCountdownTime)
                                                userInfo:nil
                                                 repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer
                                     forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (NSMutableDictionary<NSString *,WBCountdownModel *> *)timeIntervalDict {
    if (!_timeIntervalDict) {
        _timeIntervalDict = @{}.mutableCopy;
    }
    return _timeIntervalDict;
}

@end

@implementation WBCountdownModel

+ (instancetype)countdownModelWithTimeInterval:(NSInteger)timeinterval {
    WBCountdownModel *model = [[WBCountdownModel alloc]init];
    model.timeInterval = timeinterval;
    return model;
}

@end
