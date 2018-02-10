//
//  NSUserDefaults+WBAdditional.h
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (WBAdditional)

#pragma mark ------ < 第一次启动程序 > ------
/**
 Check app is need guide.

 @return YES/NO
 */
- (BOOL)wb_isNeedGuide;

@end
