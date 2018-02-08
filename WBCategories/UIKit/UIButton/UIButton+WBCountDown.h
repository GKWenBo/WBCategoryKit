//
//  UIButton+WBCountDown.h
//  WBCategories
//
//  Created by WMB on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WBCountDown)

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
          waitTittle:(NSString *)waitTittle;
/**
 *  设置按钮倒计时
 *
 *  @param time 倒计时时间
 *  @param button 对象按钮
 */
+ (void)wb_showCountDownTime:(NSUInteger)time
                    inButton:(UIButton *)button;

@end
