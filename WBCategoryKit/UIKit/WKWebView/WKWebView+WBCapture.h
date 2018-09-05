//
//  WKWebView+WBCapture.h
//  WBCategories
//
//  Created by Mr_Lucky on 2018/9/4.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (WBCapture)

/**
 WKWebView capture.

 @param completed callback.
 */
- (void)wb_wkwebViewCapture:(void (^) (UIImage *image))completed;

@end
