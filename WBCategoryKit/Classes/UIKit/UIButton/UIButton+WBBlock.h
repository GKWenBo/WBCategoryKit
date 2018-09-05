//
//  UIButton+WBBlock.h
//  WBCategories
//
//  Created by WMB on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WBButtonBlock)(UIButton *button);

@interface UIButton (WBBlock)

/**
 按钮点击block回调

 @param block block description
 */
- (void)wb_addActionHandler:(WBButtonBlock)block;

@end
