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

- (NSData *)wb_compressWithMaxLengLimit:(NSUInteger)maxLength {
    CGFloat compression = 1;
        NSData *data = UIImageJPEGRepresentation(self, compression);
        // 小于最大尺寸直接返回
    if (data.length < maxLength) {
        return data;
    }
    // 压缩质量
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i< 6; i++) {
        compression = (max + min)/2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        }else if (data.length > maxLength){
            max = compression;
        }else{
            break;
        }
    }
    
    if (data.length < maxLength) {
        return data;
    }
    
    // 压缩尺寸
    UIImage *resultImage = [UIImage imageWithData:data];
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        // 设置压缩比例
        CGFloat ratio = (CGFloat)maxLength / data.length;
        // 使用NSUInteger防止空白
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}

- (NSData *)wb_compressQualityWithMaxLengthLimit:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    while (data.length > maxLength && compression > 0) {
        compression -= 0.02;
        // 当压缩小于某个值时，将不再继续压缩
        data = UIImageJPEGRepresentation(self, compression);
    }
    return data;
}

- (NSData *)wb_compressMidQualityWithMaxLengthLimit:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

- (NSData *)wb_compressBySizeWithMaxLengthLimit:(NSUInteger)maxLength {
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        // 使用NSUInteger防止空白
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        // 使用图像绘制(drawInRect:)，图像更大，但压缩时间更多
        //使用result image绘制，图像更小，但压缩时间更短
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return data;
}

- (UIImage *)wb_compressImageWithImage:(UIImage *)image {
    //进行图像尺寸的压缩
    CGSize imageSize = image.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280||height>1280) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }
        //2.宽大于1280高小于1280
    }else if(width>1280||height<1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
        //3.宽小于1280高大于1280
    }else if(width<1280||height>1280){
        CGFloat scale = width/height;
        height = 1280;
        width = height*scale;
        //4.宽高都小于1280
    }else{
    }
    //进行尺寸重绘
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
