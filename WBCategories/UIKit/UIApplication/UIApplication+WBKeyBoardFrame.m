//
//  UIApplication+WBKeyBoardFrame.m
//  WBCategories
//
//  Created by WMB on 2018/2/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIApplication+WBKeyBoardFrame.h"

static CGRect kWBKeyBoardFrame = (CGRect){ (CGPoint){ 0.0f, 0.0f }, (CGSize){ 0.0f, 0.0f } };

@implementation UIApplication (WBKeyBoardFrame)

+ (void)load {
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardDidShowNotification object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         kWBKeyBoardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
     }];
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardDidChangeFrameNotification object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         kWBKeyBoardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
     }];
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardDidHideNotification object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         kWBKeyBoardFrame = CGRectZero;
     }];
}

#pragma mark ------ < Getter > ------
#pragma mark
- (CGRect)wb_keyBoardFame {
    return kWBKeyBoardFrame;
}

@end
