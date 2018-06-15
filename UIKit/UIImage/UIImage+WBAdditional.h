//
//  UIImage+WB_Additional.h
//  WB_UIImageUtility
//
//  Created by WMB on 2017/6/15.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIImage (WBAdditional)

#pragma mark --------  Create Image <PDF、Path、NSData 、GIF、View>  --------
#pragma mark

/**
 Create an image from a PDF file data or path.
 
 @discussion If the PDF has multiple page, is just return's the first page's
 content. Image's scale is equal to current screen's scale, size is same as
 PDF's origin size.
 
 @param dataOrPath PDF data in `NSData`, or PDF file path in `NSString`.
 
 @return A new image create from PDF, or nil when an error occurs.
 */
+ (nullable UIImage *)wb_imageWithPDF:(id)dataOrPath;
/**
 Create an image from a PDF file data or path.
 
 @discussion If the PDF has multiple page, is just return's the first page's
 content. Image's scale is equal to current screen's scale.
 
 @param dataOrPath  PDF data in `NSData`, or PDF file path in `NSString`.
 
 @param size     The new image's size, PDF's content will be stretched as needed.
 
 @return A new image create from PDF, or nil when an error occurs.
 */
+ (nullable UIImage *)wb_imageWithPDF:(id)dataOrPath
                                 size:(CGSize)size;

/**
 Create and return an image with custom draw code.
 
 @param size      The image size.
 @param drawBlock The draw block.
 
 @return The new image.
 */
+ (nullable UIImage *)wb_imageWithSize:(CGSize)size
                             drawBlock:(void (^)(CGContextRef context))drawBlock;

/**
 全屏截图

 @return 全屏截图图片
 */
+ (UIImage *)wb_shotScreen;

/**
 截取view生成一张图片

 @param view 截取的视图
 @return 视图截取生成的图片
 */
+ (UIImage *)wb_shotWithView:(UIView *)view;

/**
 截取view中某个区域生成一张图片

 @param view 要截取的视图
 @param scope 截取范围
 @return 截取生成的图片
 */
+ (UIImage *)wb_shotWithView:(UIView *)view
                       scope:(CGRect)scope;


/**
 拉伸图片指定区域

 @param insets 拉伸范围
 @return 拉伸后的图片
 */
- (UIImage *)wb_resizableImageWithInsets:(UIEdgeInsets)insets;

/**
 比例调整图片

 @param scale 比例
 @return image
 */
- (UIImage *)wb_imageByResizeToScale:(CGFloat)scale;

/**
 根据电影地址获取图片

 @param videoURL 电影地址
 @return 电影图片
 */
+ (UIImage *)wb_getVideoImage:(NSURL *)videoURL;

#pragma mark --------  Modify Image  --------
#pragma mark

CGRect YYCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);
/**
 Draws the entire image in the specified rectangle, content changed with
 the contentMode.
 
 @discussion This method draws the entire image in the current graphics context,
 respecting the image's orientation setting. In the default coordinate system,
 images are situated down and to the right of the origin of the specified
 rectangle. This method respects any transforms applied to the current graphics
 context, however.
 
 @param rect        The rectangle in which to draw the image.
 
 @param contentMode Draw content mode
 
 @param clips       A Boolean value that determines whether content are confined to the rect.
 */
- (void)wb_drawInRect:(CGRect)rect
      withContentMode:(UIViewContentMode)contentMode
        clipsToBounds:(BOOL)clips;
/**
 Returns a new image which is scaled from this image.
 The image will be stretched as needed.
 
 @param size  The new size to be scaled, values should be positive.
 
 @return      The new image with the given size.
 */
- (nullable UIImage *)wb_imageByResizeToSize:(CGSize)size;
/**
 Returns a new image which is scaled from this image.
 The image content will be changed with thencontentMode.
 
 @param size        The new size to be scaled, values should be positive.
 
 @param contentMode The content mode for image content.
 
 @return The new image with the given size.
 */
- (nullable UIImage *)wb_imageByResizeToSize:(CGSize)size
                              contentMode:(UIViewContentMode)contentMode;
/**
 Returns a new image which is cropped from this image.
 
 @param rect  Image's inner rect.
 
 @return      The new image, or nil if an error occurs.
 */
- (nullable UIImage *)wb_imageByCropToRect:(CGRect)rect;

/**
 Return a new image which is resize from this image.
 
 @param image origin image
 @param targetSize targetSize
 @return The new image, or nil if an error occurs.
 */
+ (nullable UIImage *)wb_image:(UIImage *)image
                 forTargetSize:(CGSize)targetSize;

#pragma mark --------  Border And CornerRadius  --------
#pragma mark
/**
 Returns a new image which is edge inset from this image.
 
 @param insets  Inset (positive) for each of the edges, values can be negative to 'outset'.
 
 @param color   Extend edge's fill color, nil means clear color.
 
 @return        The new image, or nil if an error occurs.
 */
- (nullable UIImage *)wb_imageByInsetEdge:(UIEdgeInsets)insets
                                withColor:(nullable UIColor *)color;
/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.
 
 @param borderColor  The border stroke color. nil means clear color.
 */
- (nullable UIImage *)wb_imageByRoundCornerRadius:(CGFloat)radius
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor;
/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.
 
 @param corners      A bitmask value that identifies the corners that you want
 rounded. You can use this parameter to round only a subset
 of the corners of the rectangle.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.
 
 @param borderColor  The border stroke color. nil means clear color.
 
 @param borderLineJoin The border line join.
 */
- (nullable UIImage *)wb_imageByRoundCornerRadius:(CGFloat)radius
                                          corners:(UIRectCorner)corners
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor
                                   borderLineJoin:(CGLineJoin)borderLineJoin;



@end
NS_ASSUME_NONNULL_END
