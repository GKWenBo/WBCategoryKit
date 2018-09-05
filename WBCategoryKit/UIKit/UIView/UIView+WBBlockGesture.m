//
//  UIView+WBBlockGesture.m
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIView+WBBlockGesture.h"
#import <objc/runtime.h>

static const void *kWBTapGestureKey = &kWBTapGestureKey;
static const void *kWBTapGestureBlockKey = &kWBTapGestureBlockKey;
static const void *kWBLongPressGestureKey = &kWBLongPressGestureKey;
static const void *kWBLongPressBlockKey = &kWBLongPressBlockKey;

@implementation UIView (WBBlockGesture)


- (void)wb_addTapGestureWithHandler:(WBTapGestureBlock)handler {
    UITapGestureRecognizer *tapGesture =objc_getAssociatedObject(self, kWBTapGestureKey);
    if (!tapGesture) {
        tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wb_tapAcion:)];
        [self addGestureRecognizer:tapGesture];
        objc_setAssociatedObject(self, kWBTapGestureKey, tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(self, kWBTapGestureBlockKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)wb_addLongPressGestureWithHandler:(WBLongPressGestureBlock)handler {
    UILongPressGestureRecognizer *longPressGesture = objc_getAssociatedObject(self, kWBLongPressGestureKey);
    if (!longPressGesture) {
        longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPressGesture];
        objc_setAssociatedObject(self, kWBLongPressGestureKey, longPressGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(self, kWBLongPressBlockKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark ------ < Event Response > ------
- (void)wb_tapAcion:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        WBTapGestureBlock block = objc_getAssociatedObject(self, kWBTapGestureBlockKey);
        if (block) {
            block(tapGestureRecognizer);
        }
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        WBLongPressGestureBlock block = objc_getAssociatedObject(self, kWBLongPressBlockKey);
        if (block) {
            block(longPressGestureRecognizer);
        }
    }
}

@end
