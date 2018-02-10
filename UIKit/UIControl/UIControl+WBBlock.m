//
//  UIControl+WBBlock.m
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIControl+WBBlock.h"

#import <objc/runtime.h>

// UIControlEventTouchDown           = 1 <<  0,      // on all touch downs
// UIControlEventTouchDownRepeat     = 1 <<  1,      // on multiple touchdowns
// (tap count > 1)
// UIControlEventTouchDragInside     = 1 <<  2,
// UIControlEventTouchDragOutside    = 1 <<  3,
// UIControlEventTouchDragEnter      = 1 <<  4,
// UIControlEventTouchDragExit       = 1 <<  5,
// UIControlEventTouchUpInside       = 1 <<  6,
// UIControlEventTouchUpOutside      = 1 <<  7,
// UIControlEventTouchCancel         = 1 <<  8,
//
// UIControlEventValueChanged        = 1 << 12,     // sliders, etc.
//
// UIControlEventEditingDidBegin     = 1 << 16,     // UITextField
// UIControlEventEditingChanged      = 1 << 17,
// UIControlEventEditingDidEnd       = 1 << 18,
// UIControlEventEditingDidEndOnExit = 1 << 19,     // 'return key' ending
// editing
//
// UIControlEventAllTouchEvents      = 0x00000FFF,  // for touch events
// UIControlEventAllEditingEvents    = 0x000F0000,  // for UITextField
// UIControlEventApplicationReserved = 0x0F000000,  // range available for
// application use
// UIControlEventSystemReserved      = 0xF0000000,  // range reserved for
// internal framework use
// UIControlEventAllEvents           = 0xFFFFFFFF


#define WB_UICONTROL_EVENT(methodName, eventName)                                \
-(void)methodName : (void (^)(void))eventBlock {                              \
objc_setAssociatedObject(self, @selector(methodName:), eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);\
[self addTarget:self                                                        \
action:@selector(methodName##Action:)                                       \
forControlEvents:UIControlEvent##eventName];                                \
}                                                                               \
-(void)methodName##Action:(id)sender {                                        \
void (^block)(void) = objc_getAssociatedObject(self, @selector(methodName:));  \
if (block) {                                                                \
block();                                                                \
}                                                                           \
}

@implementation UIControl (WBBlock)

WB_UICONTROL_EVENT(wb_touchDown, TouchDown)
WB_UICONTROL_EVENT(wb_touchDownRepeat, TouchDownRepeat)
WB_UICONTROL_EVENT(wb_touchDragInside, TouchDragInside)
WB_UICONTROL_EVENT(wb_touchDragOutside, TouchDragOutside)
WB_UICONTROL_EVENT(wb_touchDragEnter, TouchDragEnter)
WB_UICONTROL_EVENT(wb_touchDragExit, TouchDragExit)
WB_UICONTROL_EVENT(wb_touchUpInside, TouchUpInside)
WB_UICONTROL_EVENT(wb_touchUpOutside, TouchUpOutside)
WB_UICONTROL_EVENT(wb_touchCancel, TouchCancel)
WB_UICONTROL_EVENT(wb_valueChanged, ValueChanged)
WB_UICONTROL_EVENT(wb_editingDidBegin, EditingDidBegin)
WB_UICONTROL_EVENT(wb_editingChanged, EditingChanged)
WB_UICONTROL_EVENT(wb_editingDidEnd, EditingDidEnd)
WB_UICONTROL_EVENT(wb_editingDidEndOnExit, EditingDidEndOnExit)

@end
