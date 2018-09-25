//
//  UIViewController+WBAdditional.m
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIViewController+WBAdditional.h"

@implementation UIViewController (WBAdditional)

- (void)wb_hideBackButton {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

@end
