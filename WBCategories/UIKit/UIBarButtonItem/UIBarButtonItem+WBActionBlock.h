//
//  UIBarButtonItem+WBActionBlock.h
//  WBCategories
//
//  Created by WMB on 2018/2/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIBarButtonItemActionBlock)(void);

@interface UIBarButtonItem (WBActionBlock)

/**
 Action.

 @param actionBlock actionBlock description
 */
- (void)wb_actionBlock:(UIBarButtonItemActionBlock)actionBlock;

@end
