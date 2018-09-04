//
//  UIImageView+WBWebCache.m
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIImageView+WBWebCache.h"


@implementation UIImageView (WBWebCache)

- (void)wb_setImageWithURL:(NSString *)url
          placeholderImage:(NSString *)placeholder {
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:placeholder]];
}

- (void)wb_setImageWithURL:(NSString *)url
          placeholderImage:(NSString *)placeholder
                 completed:(SDExternalCompletionBlock)completedBlock {
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:placeholder]
                   completed:completedBlock];
}

- (void)wb_setImageWithFadeAnimation:(NSString *)url
                    placeholderImage:(NSString *)placeholder {
    [self wb_setImageWithFadeAnimation:url
                      placeholderImage:placeholder
                              duration:0.6f];
}

- (void)wb_setImageWithFadeAnimation:(NSString *)url
                    placeholderImage:(NSString *)placeholder
                            duration:(CGFloat)duration {
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:placeholder]
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       if (image && cacheType == SDImageCacheTypeNone) {
                           /**  < 添加交叉渐变动画 >  */
                           CATransition *animation = [CATransition animation];
                           animation.type = kCATransitionFade;
                           animation.duration = duration;
                           [weakSelf.layer addAnimation:animation forKey:@"fadeAnimation"];
                       }
    }];
}

- (void)wb_setImageWithURL:(NSString *)url
          placeholderImage:(NSString *)placeholder
                   options:(SDWebImageOptions)options
                 completed:(SDExternalCompletionBlock)completedBlock {
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:placeholder]
                     options:options
                   completed:completedBlock];
}

@end
