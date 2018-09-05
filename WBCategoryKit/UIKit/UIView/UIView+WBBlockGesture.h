//
//  UIView+WBBlockGesture.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WBTapGestureBlock)(UITapGestureRecognizer *tapGestureRecognizer);
typedef void(^WBLongPressGestureBlock)(UILongPressGestureRecognizer *lonePressGestureRecognizer);

@interface UIView (WBBlockGesture)

/**
 Add tap gesture with block.

 @param handler block handler
 */
- (void)wb_addTapGestureWithHandler:(WBTapGestureBlock)handler;

/**
 Add long press gusture with block.

 @param handler block handler
 */
- (void)wb_addLongPressGestureWithHandler:(WBLongPressGestureBlock)handler;

@end
