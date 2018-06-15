//
//  UIImage+WBCompress.m
//  WBCategories
//
//  Created by wenbo on 2018/6/15.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIImage+WBCompress.h"

static CGFloat const kBoundary = 1280.f;

@implementation UIImage (WBCompress)

#pragma mark --------  图片压缩  --------
+ (NSData *)wb_compressOriginalImage:(UIImage *)image
                 toMaxDataSizeKBytes:(CGFloat)size {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length / 1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

- (NSData *)wb_compressImageWithQuality:(CGFloat)quality {
    CGSize size = [self resizeImageWithBoundary:kBoundary];
    UIImage *reImage = [self resizeImageWithSize:size];
    NSData *imageData = UIImageJPEGRepresentation(reImage, quality);
    NSLog(@"压缩后图片大小 = %luKB",imageData.length / 1000);
    return imageData;
}

- (CGSize)resizeImageWithBoundary:(CGFloat)boundary {
    CGFloat width = self.size.width;
    CGFloat height = self.size.width;
    
    if (width < boundary || height < boundary) return CGSizeMake(width, height);
    
    CGFloat ratio = MAX(width, height) / MIN(width, height);
    if (ratio <= 2) {
        // Set the larger value to the boundary, the smaller the value of the compression
        CGFloat x = MAX(width, height) / boundary;
        if (width > height) {
            width = boundary;
            height = height / x;
        }else {
            height = boundary;
            width = width / x;
        }
    }else {
        // width, height > 1280
        if (MIN(width, height) >= boundary) {
            // Set the smaller value to the boundary, and the larger value is compressed
            CGFloat x = MIN(width, height) / boundary;
            if (width < height) {
                width = boundary;
                height = height / x;
            }else {
                height = boundary;
                width = width / x;
            }
        }
    }
    return CGSizeMake(width, height);
}

- (UIImage *)resizeImageWithSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIImage *newImage;
    UIGraphicsBeginImageContext(rect.size);
    newImage = [UIImage imageWithCGImage:self.CGImage
                                   scale:1.f
                             orientation:self.imageOrientation];
    [newImage drawInRect:rect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
