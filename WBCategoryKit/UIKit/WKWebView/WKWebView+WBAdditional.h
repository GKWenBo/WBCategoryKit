//
//  WKWebView+WBAdditional.h
//  WBWKWebView
//
//  Created by Mr_Lucky on 2018/8/28.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (WBAdditional)

/**
 允许右滑手势返回 default:NO
 */
- (void)wb_allowsBackForwardNavigationGestures;

/**
 Clear web cache.
 */
- (void)wb_clearWebCahce;

/**
 Eidt UserAgent.
 
 @param customUserAgent customUserAgent
 */
- (void)wb_setupCustomUserAgent:(NSString *)customUserAgent;

@end
