//
//  UIProgressView+WBWebKit.h
//  WBWKWebView
//
//  Created by wenbo on 2021/1/25.
//  Copyright © 2021 wenbo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIProgressView (WBWebKit)

/// 加载完成是否隐藏
@property (nonatomic, assign) BOOL wb_hiddenWhenProgressApproachFullSize;

@end

NS_ASSUME_NONNULL_END
