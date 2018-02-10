//
//  UIDevice+WBUUID.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (WBUUID)


/**
 also known as udid/uniqueDeviceIdentifier but this doesn't persists to system reset,we can use it to identifier user.

 @return uuid string.
 */
- (NSString *)wb_uuid;

@end
