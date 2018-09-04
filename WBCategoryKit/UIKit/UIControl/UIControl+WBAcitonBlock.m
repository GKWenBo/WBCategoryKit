//
//  UIControl+WBAcitonBlock.m
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIControl+WBAcitonBlock.h"
#import <objc/runtime.h>

static const void *kActionBlockArrayKey = &kActionBlockArrayKey;

@implementation WBUIControlActionBlockWrapper

- (void)wb_invokeBlock:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

@end


@implementation UIControl (WBAcitonBlock)


- (void)wb_handleControlEvents:(UIControlEvents)events withBlock:(WBUIControlActionBlock)block {
    NSMutableArray *actionBlockArray = [self wb_actionBlockArray];
    
    WBUIControlActionBlockWrapper *blockWrapper = [[WBUIControlActionBlockWrapper alloc]init];
    blockWrapper.actionBlock = block;
    blockWrapper.controlEvents = events;
    [actionBlockArray addObject:blockWrapper];
    [self addTarget:blockWrapper action:@selector(wb_invokeBlock:) forControlEvents:events];
}

- (void)wb_removeActionBlocksForControlEvents:(UIControlEvents)events {
    NSMutableArray *actionBlockArray = [self wb_actionBlockArray];
    NSMutableArray *removeActionArray = [[NSMutableArray alloc]initWithCapacity:[actionBlockArray count]];
    [actionBlockArray enumerateObjectsUsingBlock:^(WBUIControlActionBlockWrapper *wrapper, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wrapper.controlEvents == events) {
            [removeActionArray addObject:wrapper];
            [self removeTarget:wrapper action:@selector(wb_invokeBlock:) forControlEvents:events];
        }
    }];
    [actionBlockArray removeObjectsInArray:removeActionArray];
}

#pragma mark ------ < Getter > ------
- (NSMutableArray *)wb_actionBlockArray {
    NSMutableArray *actionBlockArray = objc_getAssociatedObject(self, kActionBlockArrayKey);
    if (!actionBlockArray) {
        actionBlockArray = @[].mutableCopy;
        objc_setAssociatedObject(self, kActionBlockArrayKey, actionBlockArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return actionBlockArray;
}

@end
