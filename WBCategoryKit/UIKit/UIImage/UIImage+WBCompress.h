//
//  UIImage+WBCompress.h
//  WBCategories
//
//  Created by wenbo on 2018/6/15.
//  Copyright © 2018年 WENBO. All rights reserved.
//

/** <
 参考：
 Swift：https://github.com/hucool/WXImageCompress
 Objective-C：https://github.com/IcaliaLabs/UIImage-ImageCompress
 > */

#import <UIKit/UIKit.h>

@interface UIImage (WBCompress)

#pragma mark --------  图片压缩  --------
/**
 压缩图片到指定文件大小（比较耗性能）
 
 @param image 要压缩的图片
 @param size 指定的大小，单位：KB
 @return 图片data
 */
+ (NSData *)wb_compressOriginalImage:(UIImage *)image
                 toMaxDataSizeKBytes:(CGFloat)size;

/**
 图片压缩（0.5接近微信压缩质量）
 
 @param quality 压缩比例
 @return a compressed image.
 */
- (NSData *)wb_compressImageWithQuality:(CGFloat)quality;

/// 压缩图片，先压缩质量再压缩尺寸
/// @param maxLength 最大质量
- (NSData *)wb_compressWithMaxLengLimit:(NSUInteger)maxLength;

/// 压缩图片，压缩质量
/// @param maxLength 质量
- (NSData *)wb_compressQualityWithMaxLengthLimit:(NSInteger)maxLength;

/// 图片压缩，质量压缩二分法
/// @param maxLength 最大质量
- (NSData *)wb_compressMidQualityWithMaxLengthLimit:(NSInteger)maxLength;

/// 图片压缩，压缩尺寸
/// @param maxLength 最大质量
- (NSData *)wb_compressBySizeWithMaxLengthLimit:(NSUInteger)maxLength;

/// 压缩图片尺寸（1280）
/// @param image 要压缩的图片
- (UIImage *)wb_compressImageWithImage:(UIImage *)image;

@end
