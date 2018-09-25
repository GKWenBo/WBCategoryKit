//
//  UIControl+WBSound.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (WBSound)

/**
 Play diffiernet sound with ControlEvent.

 @param fileName sound name
 @param forControlEvent UIControlEvents
 */
- (void)wb_playSoundWithFileName:(NSString *)fileName
                 forControlEvent:(UIControlEvents)forControlEvent;


@end
