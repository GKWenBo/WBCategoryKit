//
//  UIButton+WB_AdjustPosition.m
//  WB_UIButtonManager
//
//  Created by WMB on 2017/6/1.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIButton+WBAdjustPosition.h"

@implementation UIButton (WBAdjustPosition)

- (void)wb_verticalCenterImageAndTitle:(CGFloat)spacing {
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing/2), 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing/2), 0.0, 0.0, - titleSize.width);
}

- (void)wb_verticalCenterImageAndTitle {
    const int DEFAULT_SPACING = 6.0f;
    [self wb_verticalCenterImageAndTitle:DEFAULT_SPACING];
}

- (void)wb_horizontalCenterTitleAndImage:(CGFloat)spacing {
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, imageSize.width + spacing/2);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + spacing/2, 0.0, - titleSize.width);
}

- (void)wb_horizontalCenterTitleAndImage {
    const int DEFAULT_SPACING = 6.0f;
    [self wb_horizontalCenterTitleAndImage:DEFAULT_SPACING];
}

- (void)wb_horizontalCenterImageAndTitle:(CGFloat)spacing {
    // get the size of the elements here for readability
    //    CGSize imageSize = self.imageView.frame.size;
    //    CGSize titleSize = self.titleLabel.frame.size;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,  0.0, 0.0,  - spacing/2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing/2, 0.0, 0.0);
}

- (void)wb_horizontalCenterImageAndTitle {
    const int DEFAULT_SPACING = 6.0f;
    [self wb_horizontalCenterImageAndTitle:DEFAULT_SPACING];
}

- (void)wb_horizontalCenterTitleAndImageLeft:(CGFloat)spacing {
    // get the size of the elements here for readability
    //    CGSize imageSize = self.imageView.frame.size;
    //    CGSize titleSize = self.titleLabel.frame.size;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing, 0.0, 0.0);
}

- (void)wb_horizontalCenterTitleAndImageLeft {
    const int DEFAULT_SPACING = 6.0f;
    [self wb_horizontalCenterTitleAndImageLeft:DEFAULT_SPACING];
}

- (void)wb_horizontalCenterTitleAndImageRight:(CGFloat)spacing {
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + imageSize.width + spacing, 0.0, - titleSize.width);
}
- (void)wb_horizontalCenterTitleAndImageRight {
    const int DEFAULT_SPACING = 6.0f;
    [self wb_horizontalCenterTitleAndImageRight:DEFAULT_SPACING];
}
@end



