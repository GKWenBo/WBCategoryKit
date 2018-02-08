//
//  UIButton+WB_AdjustPosition.m
//  WB_UIButtonManager
//
//  Created by WMB on 2017/6/1.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIButton+WBAdjustPosition.h"

@interface UIImage (MiddleAligning)

@end

@implementation UIImage (MiddleAligning)

- (UIImage *)MiddleAlignedButtonImageScaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end

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

- (void)wb_middleAlignButtonWithSpacing:(CGFloat)spacing {
    NSString *titleString = [self titleForState:UIControlStateNormal]?:@"";
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGSize titleSize = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    CGFloat maxImageHeight = CGRectGetHeight(self.frame) - titleSize.height - spacing * 2;
    CGFloat maxImageWidth = CGRectGetWidth(self.frame);
    UIImage *newImage = nil;
    if (imageSize.width > ceilf(maxImageWidth)) {
        CGFloat ratio = maxImageWidth / imageSize.width;
        newImage = [self.imageView.image MiddleAlignedButtonImageScaleToSize:CGSizeMake(maxImageWidth, imageSize.height * ratio)];
        imageSize = newImage.size;
    }
    if (imageSize.height > ceilf(maxImageHeight)) {
        CGFloat ratio = maxImageHeight / imageSize.height;
        newImage = [self.imageView.image MiddleAlignedButtonImageScaleToSize:CGSizeMake(imageSize.width * ratio, maxImageHeight)];
        imageSize = newImage.size;
    }
    if (newImage) {
        if ([newImage respondsToSelector:@selector(imageWithRenderingMode:)]) {
            newImage = [newImage imageWithRenderingMode:self.imageView.image.renderingMode];
        }
        [self setImage:newImage forState:UIControlStateNormal];
    }
    
    CGFloat imageVerticalDiff = titleSize.height + spacing;
    CGFloat imageHorizontalDiff = titleSize.width;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(-imageVerticalDiff, 0, 0, -imageHorizontalDiff);
    
    CGFloat titleVerticalDiff = imageSize.height + spacing;
    CGFloat titleHorizontalDiff = imageSize.width;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -titleHorizontalDiff, -titleVerticalDiff, 0);
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



