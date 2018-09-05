//
//  WKWebView+WBCapture.m
//  WBCategories
//
//  Created by Mr_Lucky on 2018/9/4.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "WKWebView+WBCapture.h"

@implementation WKWebView (WBCapture)

- (void)wb_wkwebViewCapture:(void (^) (UIImage *image))completed {
    CGPoint offset = self.scrollView.contentOffset;
    UIView * snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);
    [self.superview addSubview:snapShotView];
    if (self.frame.size.height < self.scrollView.contentSize.height) {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height - self.frame.size.height);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollView.contentOffset = CGPointZero;
        [self wb_contentCaptureWithoutOffsetCallback:^(UIImage *image) {
            self.scrollView.contentOffset = offset;
            [snapShotView removeFromSuperview];
            if (completed) {
                completed(image);
            };
        }];
    });
}

- (void)wb_contentCaptureWithoutOffsetCallback:(void(^)(UIImage * image))callback{
    UIView *containerView = [[UIView alloc]initWithFrame:self.bounds];
    CGRect bakFrame = self.frame;
    UIView *bakSuperView = self.superview;
    NSUInteger bakIndex = [self.superview.subviews indexOfObject:self];
    [self removeFromSuperview];
    [containerView addSubview:self];
    
    CGSize totalSize = self.scrollView.contentSize;
    int page = floorf(totalSize.height/(float)containerView.bounds.size.height);
    self.frame = CGRectMake(0, 0, containerView.bounds.size.width, self.scrollView.contentSize.height);
    
    UIGraphicsBeginImageContextWithOptions(totalSize,  NO, [UIScreen mainScreen].scale);
    [self wb_contentPageDrawWithTargetView:containerView
                                   atIndex:0
                                  maxIndex:page
                                  callback:^{
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self removeFromSuperview];
        [bakSuperView insertSubview:self
                            atIndex:bakIndex];
        self.frame = bakFrame;
        [containerView removeFromSuperview];
        callback(capturedImage);
    }];
}

- (void)wb_contentPageDrawWithTargetView:(UIView *)targetView
                                 atIndex:(NSInteger)index
                                maxIndex:(NSInteger)maxIndex
                                callback:(void(^)(void))callback{
    CGRect splitFrame = CGRectMake(0, index * targetView.frame.size.height, targetView.bounds.size.width, targetView.bounds.size.height);
    CGRect myFrame = self.frame;
    myFrame.origin.y = - (index * targetView.frame.size.height);
    self.frame = myFrame;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [targetView drawViewHierarchyInRect:splitFrame
                         afterScreenUpdates:YES];
        if (index < maxIndex) {
            [self wb_contentPageDrawWithTargetView:targetView
                                           atIndex:index + 1
                                          maxIndex:maxIndex
                                          callback:callback];
        }else{
            callback();
        }
    });
}

@end
