//
//  UIScrollView+WBScrollDirection.m
//  Pods-WBCategoryKit_Example
//
//  Created by Mr_Lucky on 2018/11/6.
//

#import "UIScrollView+WBScrollDirection.h"

@implementation UIScrollView (WBScrollDirection)

- (WBScrollDirection)scrollDiretion {
    WBScrollDirection scrollDirection;
    if ([self.panGestureRecognizer translationInView:self.superview].y > 0.f) {
        scrollDirection = WBScrollDirectionUp;
    }else if ([self.panGestureRecognizer translationInView:self.superview].y < 0.f) {
        scrollDirection = WBScrollDirectionDown;
    }else if ([self.panGestureRecognizer translationInView:self.superview].x < 0.f) {
        scrollDirection = WBScrollDirectionLeft;
    }else if ([self.panGestureRecognizer translationInView:self.superview].x > 0.f) {
        scrollDirection = WBScrollDirectionRight;
    }else {
        scrollDirection = WBScrollDirectionWTF;
    }
    return scrollDirection;
}

@end
