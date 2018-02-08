//
//  UIButton+WB_Additional.m
//  WB_UIButtonManager
//
//  Created by WMB on 2017/6/1.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIButton+WBAdditional.h"

#import <objc/runtime.h>

static const void *UIButtonBlockKey = &UIButtonBlockKey;

@implementation UIButton (WBAdditional)

- (void)wb_addTarget:(id)target
              action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.exclusiveTouch = YES;
}

- (void)wb_addActionHandler:(ButtonTouchBlock)touchHandler {
    objc_setAssociatedObject(self, UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --------  点击Block回调  --------
#pragma mark
- (void)actionTouched:(UIButton *)btn{
    ButtonTouchBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        block(btn.tag);
    }
}

#pragma mark --------  快速创建按钮  --------
#pragma mark
/**
 *  创建按钮
 *
 *  @param title 标题
 *  @param fontSize 字体大小
 *  @param titleColor 标题颜色
 *  @param backgroundImage 背景图片
 *  @param target 监听
 *  @param action 按钮事件
 */
+ (UIButton *)wb_createButtonWithTitle:(NSString *)title
                              fontSize:(CGFloat)fontSize
                            titleColor:(UIColor *)titleColor
                       backgroundImage:(UIImage *)backgroundImage
                                target:(id)target
                                action:(SEL)action {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark --------  根据颜色设置背景图片  --------
#pragma mark
/**
 *  根据颜色设置背景图片
 *
 *  @param color 颜色
 *  @param forState 按钮状态
 */
- (void)wb_setBackgroundImageWithColor:(UIColor *)color
                              forState:(UIControlState)forState {
    [self setBackgroundImage:[UIButton imageWithColor:color] forState:forState];
}

#pragma mark --------  按钮倒计时  --------
#pragma mark
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

#pragma mark --------  private method  --------
#pragma mark
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
