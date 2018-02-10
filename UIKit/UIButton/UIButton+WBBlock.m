//
//  UIButton+WBBlock.m
//  WBCategories
//
//  Created by WMB on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIButton+WBBlock.h"

#import <objc/runtime.h>

static const void *kButtonActionKey = &kButtonActionKey;

@implementation UIButton (WBBlock)

- (void)wb_addActionHandler:(WBButtonBlock)block {
    objc_setAssociatedObject(self, kButtonActionKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(wb_buttonActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ------ < Event Response > ------
#pragma mark
- (void)wb_buttonActionBlock:(UIButton *)sender {
    WBButtonBlock block = objc_getAssociatedObject(self, kButtonActionKey);
    if (block) {
        block(sender);
    }
}

@end
