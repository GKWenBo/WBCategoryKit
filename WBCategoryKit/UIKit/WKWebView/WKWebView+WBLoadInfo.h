//
//  WKWebView+WBLoadInfo.h
//  WBWKWebView
//
//  Created by 文波 on 2018/8/28.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <WebKit/WebKit.h>

typedef void(^WBWKWebViewLoadInfoBlock)(double estimatedProgress, CGSize contentSize, WKWebView *wkWebView);

typedef NS_ENUM(NSInteger, WBWKWebViewLoadState) {
    WBWKWebViewLoadState_uninitialized = 0, //还未开始载入
    WBWKWebViewLoadState_loading,           //载入中
    WBWKWebViewLoadState_interactive,       //已加载，文档与用户可以开始交互
    WBWKWebViewLoadState_complete           //载入完成
};

@interface WKWebView (WBLoadInfo) <WKNavigationDelegate>

/** < Web contentSize > */
@property (nonatomic, assign, readonly) CGSize wb_contentSize;
/** < Loading progress > */
@property (nonatomic, assign, readonly) double wb_estimatedProgress;
/** < Load state > */
@property (nonatomic, assign, readonly) WBWKWebViewLoadState wb_loadState;
/** < Web Load Change Block > */
@property (nonatomic, copy) WBWKWebViewLoadInfoBlock wb_wkWebViewLoadInfoBlock;

@end
