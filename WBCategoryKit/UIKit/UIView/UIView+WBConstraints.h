//
//  UIView+WBConstraints.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

/**  <
    Get view's constraints.
 >  */

#import <UIKit/UIKit.h>

@interface UIView (WBConstraints)

- (NSLayoutConstraint *)wb_constraintForAttribute:(NSLayoutAttribute)attribute;
- (NSLayoutConstraint *)wb_leftConstraint;
- (NSLayoutConstraint *)wb_rightConstraint;
- (NSLayoutConstraint *)wb_topConstraint;
- (NSLayoutConstraint *)wb_bottomConstraint;
- (NSLayoutConstraint *)wb_leadingConstraint;
- (NSLayoutConstraint *)wb_trailingConstraint;
- (NSLayoutConstraint *)wb_widthConstraint;
- (NSLayoutConstraint *)wb_heightConstraint;
- (NSLayoutConstraint *)wb_centerXConstraint;
- (NSLayoutConstraint *)wb_centerYConstraint;
- (NSLayoutConstraint *)wb_baseLineConstraint;

@end
