//
//  UINavigationItem+WBLock.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (WBLock)

/**
 Lock right item.

 @param lock Lock Or Unlock.
 */
- (void)wb_lockRightItem:(BOOL)lock;

/**
 Lock left item.

 @param lock Lock Or Unlock.
 */
- (void)wb_lockLeftItem:(BOOL)lock;

@end
