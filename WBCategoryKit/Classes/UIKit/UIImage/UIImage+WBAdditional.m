//
//  UIImage+WB_Additional.m
//  WB_UIImageUtility
//
//  Created by WMB on 2017/6/15.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIImage+WBAdditional.h"
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <CoreText/CoreText.h>
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (WBAdditional)

#pragma mark --------  Create Image <PDF、Path、NSData、Color、GIF>  --------
+ (nullable UIImage *)wb_imageWithPDF:(id)dataOrPath {
    
    return [self wb_imageWithPDF:dataOrPath
                          resize:NO
                            size:CGSizeZero];
}

+ (nullable UIImage *)wb_imageWithPDF:(id)dataOrPath
                                 size:(CGSize)size {
    return [self wb_imageWithPDF:dataOrPath
                          resize:YES
                            size:size];
}

+ (nullable UIImage *)wb_imageWithSize:(CGSize)size
                             drawBlock:(void (^)(CGContextRef context))drawBlock{
    if (!drawBlock) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)wb_shotScreen {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContext(window.bounds.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)wb_shotWithView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)wb_shotWithView:(UIView *)view
                       scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self wb_shotWithView:view].CGImage, scope);
    UIGraphicsBeginImageContext(scope.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return image;
}

- (UIImage *)wb_resizableImageWithInsets:(UIEdgeInsets)insets {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f) {
        return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    
    return [self stretchableImageWithLeftCapWidth:insets.left topCapHeight:insets.top];
}

- (UIImage *)wb_imageByResizeToScale:(CGFloat)scale {
    CGSize size = CGSizeMake(self.size.width *scale, self.size.height * scale);
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)wb_getVideoImage:(NSURL *)videoURL {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

#pragma mark --------  Modify Image  --------
CGRect YYCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode) {
    rect = CGRectStandardize(rect);
    size.width = size.width < 0 ? -size.width : size.width;
    size.height = size.height < 0 ? -size.height : size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    switch (mode) {
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill: {
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center;
                rect.size = CGSizeZero;
            } else {
                CGFloat scale;
                if (mode == UIViewContentModeScaleAspectFit) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height;
                    } else {
                        scale = rect.size.width / size.width;
                    }
                } else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width;
                    } else {
                        scale = rect.size.height / size.height;
                    }
                }
                size.width *= scale;
                size.height *= scale;
                rect.size = size;
                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
            }
        } break;
        case UIViewContentModeCenter: {
            rect.size = size;
            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
        } break;
        case UIViewContentModeTop: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeBottom: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeLeft: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeRight: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeTopLeft: {
            rect.size = size;
        } break;
        case UIViewContentModeTopRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeBottomLeft: {
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeBottomRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
        default: {
            rect = rect;
        }
    }
    return rect;
}

- (void)wb_drawInRect:(CGRect)rect
      withContentMode:(UIViewContentMode)contentMode
        clipsToBounds:(BOOL)clips {
    CGRect drawRect = YYCGRectFitWithContentMode(rect, self.size, contentMode);
    if (drawRect.size.width == 0 || drawRect.size.height == 0) return;
    if (clips) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context) {
            CGContextSaveGState(context);
            CGContextAddRect(context, rect);
            CGContextClip(context);
            [self drawInRect:drawRect];
            CGContextRestoreGState(context);
        }
    } else {
        [self drawInRect:drawRect];
    }
}

- (nullable UIImage *)wb_imageByResizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (nullable UIImage *)wb_imageByResizeToSize:(CGSize)size
                                 contentMode:(UIViewContentMode)contentMode {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self wb_drawInRect:CGRectMake(0, 0, size.width, size.height)
        withContentMode:contentMode
          clipsToBounds:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (nullable UIImage *)wb_imageByCropToRect:(CGRect)rect {
    rect.origin.x *= self.scale;
    rect.origin.y *= self.scale;
    rect.size.width *= self.scale;
    rect.size.height *= self.scale;
    if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

+ (nullable UIImage *)wb_image:(UIImage *)image
                 forTargetSize:(CGSize)targetSize {
    if(!image) return nil;
    CGSize imageSize = image.size;
    /**  < 图片宽高 >  */
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    /**  < 声明一个判断属性 >  */
    NSInteger judge = 0;
    if (imageHeight - imageWidth > 0) {
        CGFloat tempW = targetSize.width;
        CGFloat tempH = targetSize.height;
        targetSize.height= tempW;
        targetSize.width= tempH;
    }
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.f;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointZero;
    /**  < 第一个判断,图片大小宽跟高都小于目标尺寸,直接返回image >  */
    if (imageHeight < targetHeight && imageWidth < targetWidth) {
        return image;
    }
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        /**  < 这里是目标宽度除以图片宽度 >  */
        CGFloat widthFactor = targetWidth / imageWidth;
        /**  < 这里是目标高度除以图片高度 >  */
        CGFloat heightFactor = targetHeight / imageHeight;
        
        /**  < 分四种情况 >  */
        /**  < 第一种,widthFactor,heightFactor都小于1,也就是图片宽度跟高度都比目标图片大,要缩小 >  */
        if (widthFactor < 1 && heightFactor < 1) {
            /**  < 第一种,需要判断要缩小哪一个尺寸,这里看拉伸尺度,我们的scale在小于1的情况下,谁越小,等下就用原图的宽度高度✖️那一个系数(这里不懂的话,代个数想一下,例如目标800*480  原图1600*800  系数就采用宽度系数widthFactor = 1/2  ) >  */
            if (widthFactor > heightFactor) {
                /**  < 右部分空白 >  */
                judge = 1;
                /**  < 修改最后的拉伸系数是高度系数(也就是最后要*这个值) >  */
                scaleFactor = heightFactor;
            }else {
                /**  < 下部分空白 >  */
                judge = 2;
                scaleFactor = widthFactor;
            }
        }else if (widthFactor > 1 && heightFactor < 1) {
            /**  < 第二种,宽度不够比例,高度缩小一点点(widthFactor大于一,说明目标宽度比原图片宽度大,此时只要拉伸高度系数) >  */
            /**  < 下部分空白  >  */
            judge = 3;
            /**  < 采用高度拉伸比例 >  */
            /**  < 计算高度缩小系数  >  */
            scaleFactor = imageWidth / targetWidth;
        }else if (heightFactor > 1 && widthFactor < 1) {
            /**  < 第三种,高度不够比例,宽度缩小一点点(heightFactor大于一,说明目标高度比原图片高度大,此时只要拉伸宽度系数) >  */
            /**  < 下边空白 >  */
            judge = 4;
            /**  < 采用高度拉伸比例 >  */
            scaleFactor = imageHeight / targetWidth;
        }else {
            /**  <  //第四种,此时宽度高度都小于目标尺寸,不必要处理放大(如果有处理放大的,在这里写). >  */
        }
        scaledWidth = imageWidth * scaleFactor;
        scaledHeight = imageHeight * scaleFactor;
    }
    
    if (judge == 1) {
        /**  < 右部分空白 >  */
        /**  < 此时把原来目标剪切的宽度改小,例如原来可能是800,现在改成780
         
         >  */
        targetWidth = scaledWidth;
    }else if (judge == 2) {
        /**  < 下部分空 >  */
        targetHeight = scaledHeight;
    }else if (judge == 3) {
        /**  < 第三种,高度不够比例,宽度缩小一点点 >  */
        targetWidth = scaledWidth;
    }else {
        /**  < 第三种,高度不够比例,宽度缩小一点点 >  */
        targetHeight = scaledHeight;
    }
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin= thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height= scaledHeight;
    [image drawInRect:thumbnailRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

#pragma mark --------  Border And CornerRadius  --------
- (nullable UIImage *)wb_imageByInsetEdge:(UIEdgeInsets)insets
                                withColor:(nullable UIColor *)color{
    CGSize size = self.size;
    size.width -= insets.left + insets.right;
    size.height -= insets.top + insets.bottom;
    if (size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(-insets.left, -insets.top, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (color) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CGPathAddRect(path, NULL, rect);
        CGContextAddPath(context, path);
        CGContextEOFillPath(context);
        CGPathRelease(path);
    }
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (nullable UIImage *)wb_imageByRoundCornerRadius:(CGFloat)radius
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor{
    return [self wb_imageByRoundCornerRadius:radius
                                     corners:UIRectCornerAllCorners
                                 borderWidth:borderWidth
                                 borderColor:borderColor
                              borderLineJoin:kCGLineJoinMiter];
}

- (nullable UIImage *)wb_imageByRoundCornerRadius:(CGFloat)radius
                                          corners:(UIRectCorner)corners
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor
                                   borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)wb_imageWithPDF:(id)dataOrPath
                      resize:(BOOL)resize
                        size:(CGSize)size {
    CGPDFDocumentRef pdf = NULL;
    if ([dataOrPath isKindOfClass:[NSData class]]) {
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)dataOrPath);
        pdf = CGPDFDocumentCreateWithProvider(provider);
        CGDataProviderRelease(provider);
    } else if ([dataOrPath isKindOfClass:[NSString class]]) {
        pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:dataOrPath]);
    }
    if (!pdf) return nil;
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 1);
    if (!page) {
        CGPDFDocumentRelease(pdf);
        return nil;
    }
    
    CGRect pdfRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGSize pdfSize = resize ? size : pdfRect.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, pdfSize.width * scale, pdfSize.height * scale, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    if (!ctx) {
        CGColorSpaceRelease(colorSpace);
        CGPDFDocumentRelease(pdf);
        return nil;
    }
    
    CGContextScaleCTM(ctx, scale, scale);
    CGContextTranslateCTM(ctx, -pdfRect.origin.x, -pdfRect.origin.y);
    CGContextDrawPDFPage(ctx, page);
    CGPDFDocumentRelease(pdf);
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    UIImage *pdfImage = [[UIImage alloc] initWithCGImage:image scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(image);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    return pdfImage;
}

@end
