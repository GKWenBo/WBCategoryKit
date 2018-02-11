//
//  UIWebView+WBSwipeGesture.m
//  WBCategories
//
//  Created by Admin on 2018/2/11.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIWebView+WBSwipeGesture.h"

@interface UIWebView () <UIGestureRecognizerDelegate>

@end

@implementation UIWebView (WBSwipeGesture)

- (void)wb_useSwipeGesture {
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(wb_swipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRight setNumberOfTouchesRequired:2];
    [swipeRight setDelegate:self];
    [self addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(wb_swipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeft setNumberOfTouchesRequired:2];
    [swipeLeft setDelegate:self];
    [self addGestureRecognizer:swipeLeft];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan setMaximumNumberOfTouches:2];
    [pan setMinimumNumberOfTouches:2];
    [self addGestureRecognizer:pan];
    
    [pan requireGestureRecognizerToFail:swipeLeft];
    [pan requireGestureRecognizerToFail:swipeRight];
}

- (void)wb_swipeRight:(UISwipeGestureRecognizer *)recognizer {
    if([recognizer numberOfTouches] == 2 && [self canGoBack]) [self goBack];
}

- (void)wb_swipeLeft:(UISwipeGestureRecognizer *)recognizer {
    if([recognizer numberOfTouches] == 2 && [self canGoForward]) [self goForward];
}

@end
