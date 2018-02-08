//
//  UITableViewCell+FindUITableView.m
//  MyDemo
//
//  Created by Admin on 2017/11/1.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "UITableViewCell+FindUITableView.h"

@implementation UITableViewCell (FindUITableView)

- (UITableView *)wb_parentTableView {
    UIView *aView = self.superview;
    while (aView != nil) {
        if ([aView isKindOfClass:[UITableView class]]) {
            return (UITableView *)aView;
        }
        aView = aView.superview;
    }
    return nil;
}
@end
