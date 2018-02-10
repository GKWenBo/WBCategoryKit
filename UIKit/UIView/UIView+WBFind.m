//
//  UIView+WBFind.m
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIView+WBFind.h"

@implementation UIView (WBFind)

#pragma mark ------ < Getter > ------
- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
/**  < 法2 >  */
//- (UIViewController *)viewController {
//    UIResponder *responder = [self nextResponder];
//    while (responder) {
//        if ([responder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)responder;
//        }
//        responder = [responder nextResponder];
//    }
//    return nil;
//}

- (id)wb_findSubViewWithSubViewClass:(Class)clazz {
    for (id subview in self.subviews) {
        if ([subview isKindOfClass:clazz]) {
            return subview;
        }
    }
    return nil;
}

- (id)wb_findSuperViewWithSuperViewClass:(Class)clazz {
    if (self == nil) {
        return nil;
    }else if (self.superview == nil) {
        return nil;
    }else if ([self.superview isKindOfClass:clazz]) {
        return self.superview;
    }else {
        return [self wb_findSuperViewWithSuperViewClass:clazz];
    }
}

- (BOOL)wb_findAndResignFirstResponder {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    
    for (UIView *view in self.subviews) {
        if ([view wb_findAndResignFirstResponder]) {
            return YES;
        }
    }
    return NO;
}

- (UIView *)wb_findFirstResponder {
    if (([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]])
        && (self.isFirstResponder)) {
        return self;
    }
    for (UIView *v in self.subviews) {
        UIView *fv = [v wb_findFirstResponder];
        if (fv) {
            return fv;
        }
    }
    return nil;
}

@end
