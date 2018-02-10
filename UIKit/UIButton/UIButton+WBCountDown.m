//
//  UIButton+WBCountDown.m
//  WBCategories
//
//  Created by WMB on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIButton+WBCountDown.h"

@implementation UIButton (WBCountDown)

#pragma mark --------  按钮倒计时  --------
/**
 *  设置按钮倒计时
 *
 *  @param timeout 倒计时时间
 *  @param tittle 按钮标题
 *  @param waitTittle 等待标题
 */
- (void)wb_startTime:(NSInteger )timeout
               title:(NSString *)tittle
          waitTittle:(NSString *)waitTittle {
    __block NSInteger timeOut=timeout; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:tittle forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [self setTitle:[NSString stringWithFormat:@"%@%@",strTime,waitTittle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                
            });
            timeOut--;
            
        }
    });
    dispatch_resume(_timer);
}
/**
 *  设置按钮倒计时
 *
 *  @param time 倒计时时间
 *  @param button 对象按钮
 */
+ (void)wb_showCountDownTime:(NSUInteger)time
                    inButton:(UIButton *)button {
    __block int timeout = (int)time;
    /**  创建定时器  */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    /**  每秒执行一次  */
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:@"验证" forState:UIControlStateNormal];
                button.enabled = YES;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout-1;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                button.enabled = NO;
                NSString *timeString = [NSString stringWithFormat:@"%@秒",strTime];
                button.titleLabel.text = timeString;
                [button setTitle: timeString forState:UIControlStateDisabled];
                [button setTitleColor:[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0] forState:UIControlStateDisabled];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
