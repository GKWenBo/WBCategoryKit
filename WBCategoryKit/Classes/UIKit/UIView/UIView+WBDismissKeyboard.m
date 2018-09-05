//
//  UIView+WBDismissKeyboard.m
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIView+WBDismissKeyboard.h"
#import "UIView+WBFind.h"

@implementation UIView (WBDismissKeyboard)

- (void)wb_dismissKeyBoard {
    [[self wb_findFirstResponder] resignFirstResponder];
}

//- (UIView *)wb_findFirstResponder {
//    for (UIView *view in self.subviews) {
//        if ([view isFirstResponder] && [view respondsToSelector:@selector(isFirstResponder)]) {
//            return view;
//        }
//        UIView *result = [self wb_findFirstResponder];
//        if (result) {
//            return result;
//        }
//    }
//    return nil;
//}

@end
