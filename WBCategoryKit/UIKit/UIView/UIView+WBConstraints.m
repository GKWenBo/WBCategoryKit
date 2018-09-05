//
//  UIView+WBConstraints.m
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIView+WBConstraints.h"

@implementation UIView (WBConstraints)

- (NSLayoutConstraint *)wb_constraintForAttribute:(NSLayoutAttribute)attribute {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d && (firstItem = %@ || secondItem = %@)", attribute, self, self];
    NSArray *constraintArray = [self.superview constraints];
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        constraintArray = [self constraints];
    }
    NSArray *fillteredArray = [constraintArray filteredArrayUsingPredicate:predicate];
    if(fillteredArray.count == 0) {
        return nil;
    } else {
        return fillteredArray.firstObject;
    }
}

- (NSLayoutConstraint *)wb_leftConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeLeft];
}

- (NSLayoutConstraint *)wb_rightConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeRight];
}

- (NSLayoutConstraint *)wb_topConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeTop];
}

- (NSLayoutConstraint *)wb_bottomConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeBottom];
}

- (NSLayoutConstraint *)wb_leadingConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeLeading];
}

- (NSLayoutConstraint *)wb_trailingConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeTrailing];
}

- (NSLayoutConstraint *)wb_widthConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeWidth];
}

- (NSLayoutConstraint *)wb_heightConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeHeight];
}

- (NSLayoutConstraint *)wb_centerXConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeCenterX];
}

- (NSLayoutConstraint *)wb_centerYConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeCenterY];
}

- (NSLayoutConstraint *)wb_baseLineConstraint {
    return [self wb_constraintForAttribute:NSLayoutAttributeBaseline];
}

@end
