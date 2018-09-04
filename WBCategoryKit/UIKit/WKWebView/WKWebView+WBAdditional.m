//
//  WKWebView+WBAdditional.m
//  WBWKWebView
//
//  Created by Mr_Lucky on 2018/8/28.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WKWebView+WBAdditional.h"

@implementation WKWebView (WBAdditional)

- (void)wb_allowsBackForwardNavigationGestures {
    self.allowsBackForwardNavigationGestures = YES;
}

@end
