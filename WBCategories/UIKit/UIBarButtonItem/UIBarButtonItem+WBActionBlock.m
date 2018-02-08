//
//  UIBarButtonItem+WBActionBlock.m
//  WBCategories
//
//  Created by WMB on 2018/2/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIBarButtonItem+WBActionBlock.h"

#import <objc/runtime.h>

static const void *kBarButtonItemActionKey = &kBarButtonItemActionKey;

@implementation UIBarButtonItem (WBActionBlock)

#pragma mark ------ < Getter > ------
#pragma mark
- (UIBarButtonItemActionBlock)wb_actionBlock {
    return objc_getAssociatedObject(self, kBarButtonItemActionKey);
}

- (void)wb_actionBlock:(UIBarButtonItemActionBlock)actionBlock {
    if (actionBlock != self.wb_actionBlock) {
        [self willChangeValueForKey:@"wb_actionBlock"];
        objc_setAssociatedObject(self, kBarButtonItemActionKey, actionBlock, OBJC_ASSOCIATION_COPY);
        [self setTarget:self];
        [self setAction:@selector(wb_performActionBlock)];
        [self didChangeValueForKey:@"wb_actionBlock"];
    }
}

#pragma mark ------ < Action > ------
#pragma mark
- (void)wb_performActionBlock {
    dispatch_block_t block = self.wb_actionBlock;
    if (block) {
        block();
    }
}

@end
