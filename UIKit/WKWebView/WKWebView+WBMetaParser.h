//
//  WKWebView+WBMetaParser.h
//  WBWKWebView
//
//  Created by Mr_Lucky on 2018/8/28.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (WBMetaParser)

/**
 Get HTML meta info（NSArray）.

 @param completed 回调
 */
- (void)wb_getMetaData:(void (^) (NSArray *metaData))completed;

@end
