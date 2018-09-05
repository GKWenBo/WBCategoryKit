//
//  UIControl+WBIgnoreMutiple.h
//  WBCategories
//
//  Created by wenbo on 2018/5/14.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (WBIgnoreMutiple)

/** < Set respond time interval >  */
@property (nonatomic, assign) NSTimeInterval wb_acceptEventTimeInterval;
/** < Whether to response to events >  */
@property (nonatomic, assign) BOOL wb_ignoreEvent;

@end
