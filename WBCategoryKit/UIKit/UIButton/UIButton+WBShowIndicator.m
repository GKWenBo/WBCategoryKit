//
//  UIButton+WBShowIndicator.m
//  WBCategories
//
//  Created by WMB on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIButton+WBShowIndicator.h"
#import <objc/runtime.h>

static const void *kIndicatorKey = &kIndicatorKey;
static const void *kButtonTitleKey = &kButtonTitleKey;

@implementation UIButton (WBShowIndicator)

- (void)wb_showIndicator {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    NSString *currentTitle = self.titleLabel.text;
    objc_setAssociatedObject(self, kButtonTitleKey, currentTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kIndicatorKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitle:@"" forState:UIControlStateNormal];
    self.enabled = NO;
    [self addSubview:indicator];
}

- (void)wb_hideIndicator {
    NSString *currentTitle = objc_getAssociatedObject(self, kButtonTitleKey);
    UIActivityIndicatorView *indicator = objc_getAssociatedObject(self, kIndicatorKey);
    [indicator removeFromSuperview];
    [self setTitle:currentTitle forState:UIControlStateNormal];
    self.enabled = YES;
}

@end
