//
//  WKWebView+WBLoadInfo.m
//  WBWKWebView
//
//  Created by 文波 on 2018/8/28.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WKWebView+WBLoadInfo.h"
#import <objc/runtime.h>

static char kWBWKWebLoadInfoBlockKey;
static char kWBEstimatedProgressKey;
static char kWBContentSizeKey;
static char kWBLoadStateKey;
static char kWBLoadingCountKey;
static char kWBMaxLoadCountKey;
static char kWBCurrentURLKey;
static char kWBInteractiveKey;
static char kWBRealNavigationDelegateKey;

NSString *wb_completeRPCURLPath = @"/wbwebviewprogressproxy/complete";


@interface WKWebView ()

@property (nonatomic, assign) NSUInteger wb_loadingCount;
@property (nonatomic, assign) NSUInteger wb_maxLoadCount;
@property (nonatomic, strong) NSURL *wb_currentURL;
@property (nonatomic, assign) BOOL wb_interactive;
@property (nonatomic, assign) id <WKNavigationDelegate> wb_realNavigationDelegate;

@end

@implementation WKWebView (WBLoadInfo)

// MARK:Setter && Getter
- (void)setWb_loadingCount:(NSUInteger)wb_loadingCount {
    objc_setAssociatedObject(self, &kWBLoadingCountKey, @(wb_loadingCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)wb_loadingCount {
    return [objc_getAssociatedObject(self, &kWBLoadingCountKey) unsignedIntegerValue];
}

- (void)setWb_maxLoadCount:(NSUInteger)wb_maxLoadCount {
    objc_setAssociatedObject(self, &kWBMaxLoadCountKey, @(wb_maxLoadCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)wb_maxLoadCount {
    return [objc_getAssociatedObject(self, &kWBMaxLoadCountKey) unsignedIntegerValue];
}

- (void)setWb_currentURL:(NSURL *)wb_currentURL {
    objc_setAssociatedObject(self, &kWBCurrentURLKey, wb_currentURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL *)wb_currentURL {
    return objc_getAssociatedObject(self, &kWBCurrentURLKey);
}

- (void)setWb_interactive:(BOOL)wb_interactive {
    objc_setAssociatedObject(self, &kWBInteractiveKey, @(wb_interactive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wb_interactive {
    return [objc_getAssociatedObject(self, &kWBInteractiveKey) boolValue];
}

- (void)setWb_estimatedProgress:(double)wb_estimatedProgress {
    objc_setAssociatedObject(self, &kWBEstimatedProgressKey, @(wb_estimatedProgress), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (double)wb_estimatedProgress {
    return [objc_getAssociatedObject(self, &kWBEstimatedProgressKey) doubleValue];
}

- (void)setWb_contentSize:(CGSize)wb_contentSize {
    objc_setAssociatedObject(self, &kWBContentSizeKey, [NSValue valueWithCGSize:wb_contentSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)wb_contentSize {
    return [objc_getAssociatedObject(self, &kWBContentSizeKey) CGSizeValue];
}

- (void)setWb_loadState:(WBWKWebViewLoadState)wb_loadState {
    objc_setAssociatedObject(self, &kWBLoadStateKey, @(wb_loadState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WBWKWebViewLoadState)wb_loadState {
    return [objc_getAssociatedObject(self, &kWBLoadStateKey) integerValue];
}

- (void)setWb_realNavigationDelegate:(id<WKNavigationDelegate>)wb_realDelegate {
    objc_setAssociatedObject(self, &kWBRealNavigationDelegateKey, wb_realDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<WKNavigationDelegate>)wb_realNavigationDelegate {
    return objc_getAssociatedObject(self, &kWBRealNavigationDelegateKey);
}

- (void)setWb_wkWebViewLoadInfoBlock:(WBWKWebViewLoadInfoBlock)wb_wkWebViewLoadInfoBlock {
    [self wb_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, &kWBWKWebLoadInfoBlockKey, wb_wkWebViewLoadInfoBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (WBWKWebViewLoadInfoBlock)wb_wkWebViewLoadInfoBlock {
    return objc_getAssociatedObject(self, &kWBWKWebLoadInfoBlockKey);
}

// MARK:WKNavigationDelegate
/** < 判断链接是否允许跳转 > */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.path isEqualToString:wb_completeRPCURLPath]) {
        [self wb_completeProgress];
        return;
    }
    
    if ([self.wb_realNavigationDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self.wb_realNavigationDelegate webView:webView
      decidePolicyForNavigationAction:navigationAction
                      decisionHandler:decisionHandler];
    }
    BOOL isFragmentJump = NO;
    if (navigationAction.request.URL.fragment) {
        NSString *nonFragmentURL = [navigationAction.request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:navigationAction.request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [navigationAction.request.mainDocumentURL isEqual:navigationAction.request.URL];
    
    BOOL isHTTPOrLocalFile = [navigationAction.request.URL.scheme isEqualToString:@"http"] || [navigationAction.request.URL.scheme isEqualToString:@"https"] || [navigationAction.request.URL.scheme isEqualToString:@"file"];
    if (!isFragmentJump && isHTTPOrLocalFile && isTopLevelNavigation) {
        self.wb_currentURL = navigationAction.request.URL;
        [self wb_reset];
    }
}

/** < 链接开始加载时调用 > */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.wb_loadState = WBWKWebViewLoadState_loading;
    if ([self.wb_realNavigationDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [self.wb_realNavigationDelegate webView:webView
        didStartProvisionalNavigation:navigation];
    }
    
    self.wb_loadingCount ++;
    self.wb_maxLoadCount = fmax(self.wb_maxLoadCount, self.wb_loadingCount);
    [self wb_startProgress];
}

/** < 加载完成 > */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([self.wb_realNavigationDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.wb_realNavigationDelegate webView:webView
                  didFinishNavigation:navigation];
    }
    
    self.wb_loadingCount --;
    [self wb_incrementProgress];
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.readyState"
              completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                  __strong typeof(self) strongSelf = weakSelf;
                  NSString *readyState = (NSString *)result;
                  BOOL interactive = [readyState isEqualToString:@"interactive"];;
                  if (interactive) {
                      strongSelf.wb_interactive = YES;
                      strongSelf.wb_loadState = WBWKWebViewLoadState_interactive;
                      
                      NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.URL.scheme, webView.URL.host, wb_completeRPCURLPath];
                      [webView evaluateJavaScript:waitForCompleteJS
                                completionHandler:nil];
                  }
                  BOOL isNotRedirect = strongSelf.wb_currentURL && [strongSelf.wb_currentURL isEqual:webView.URL];
                  BOOL complete = [readyState isEqualToString:@"complete"];
                  if (complete && isNotRedirect) {
                      [strongSelf wb_completeProgress];
                  }
              }];
}

/** < 加载失败 > */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if ([self.wb_realNavigationDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [self.wb_realNavigationDelegate webView:webView
         didFailProvisionalNavigation:navigation
                            withError:error];
    }
    
    self.wb_loadingCount --;
    [self wb_incrementProgress];
    
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.readyState"
              completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                  __strong typeof(self) strongSelf = weakSelf;
                  NSString *readyState = (NSString *)result;
                  BOOL interactive = [readyState isEqualToString:@"interactive"];;
                  if (interactive) {
                      strongSelf.wb_interactive = YES;
                      NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.URL.scheme, webView.URL.host, wb_completeRPCURLPath];
                      [webView evaluateJavaScript:waitForCompleteJS
                                completionHandler:nil];
                  }
                  BOOL isNotRedirect = strongSelf.wb_currentURL && [strongSelf.wb_currentURL isEqual:webView.URL];
                  BOOL complete = [readyState isEqualToString:@"complete"];
                  if ((complete && isNotRedirect) || error) {
                      [strongSelf wb_completeProgress];
                  }
              }];
}

// MARK:Private Method
- (void)wb_completeProgress
{
    self.wb_loadState = WBWKWebViewLoadState_complete;
    [self wb_updateProgress:1.0];
    //    CGFloat webViewHeight= [[self stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    //    NSLog(@"body.offsetHeight:%lf",webViewHeight);
    //
    //    CGFloat webViewHeight2=self.scrollView.contentSize.height;
    //    NSLog(@"scrollView contentSize:%lf",webViewHeight2);
}

- (void)wb_updateProgress:(double)progress
{
    if (progress > self.wb_estimatedProgress || progress == 0) {
        self.wb_estimatedProgress = progress;
        self.wb_contentSize = self.scrollView.contentSize;
        if (self.wb_wkWebViewLoadInfoBlock) {
            self.wb_wkWebViewLoadInfoBlock(self.wb_estimatedProgress,self.scrollView.contentSize,self);
        }
    }
}

- (void)wb_reset
{
    self.wb_maxLoadCount = self.wb_loadingCount = 0;
    self.wb_interactive = NO;
    [self wb_updateProgress:0.0];
    self.wb_loadState = WBWKWebViewLoadState_uninitialized;
}

- (void)wb_startProgress
{
    if (self.wb_estimatedProgress < 0.1) {
        [self wb_updateProgress:0.1];
    }
}

- (void)wb_incrementProgress
{
    double progress = self.wb_estimatedProgress;
    double maxProgress = self.wb_interactive ? 0.9 : 0.5f;
    double remainPercent = (double)self.wb_loadingCount / (double)self.wb_maxLoadCount;
    double increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self wb_updateProgress:progress];
}

// MARK:Delegate Forwarder
- (void)wb_setDelegateIfNoDelegateSet
{
    if (self.navigationDelegate != (id<WKNavigationDelegate>)self) {
        self.wb_realNavigationDelegate  = self.navigationDelegate;
        self.navigationDelegate = (id<WKNavigationDelegate>)self;
    }
}

@end
