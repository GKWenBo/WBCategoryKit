//
//  UIImage+WB_Rotate.h
//  WB_UIImageUtility
//
//  Created by WMB on 2017/6/16.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIImage (WBRotate)
#pragma mark --------  Rotate --------
#pragma mark
/**
 修正图片方向

 @param aImage 要修正的图片
 @return 修正后的图片
 */
+ (UIImage *)wb_fixOrientation:(UIImage *)aImage;
/**
 Returns a new rotated image (relative to the center).
 
 @param radians   Rotated radians in counterclockwise.⟲
 
 @param fitSize   YES: new image's size is extend to fit all content.
 NO: image's size will not change, content may be clipped.
 */
- (nullable UIImage *)wb_imageByRotate:(CGFloat)radians
                               fitSize:(BOOL)fitSize;
/**
 Returns a new image rotated counterclockwise by a quarter‑turn (90°). ⤺
 The width and height will be exchanged.
 */
- (nullable UIImage *)wb_imageByRotateLeft90;
/**
 Returns a new image rotated clockwise by a quarter‑turn (90°). ⤼
 The width and height will be exchanged.
 */
- (nullable UIImage *)wb_imageByRotateRight90;
/**
 Returns a new image rotated 180° . ↻
 */
- (nullable UIImage *)wb_imageByRotate180;
/**
 Returns a vertically flipped image. ⥯
 */
- (nullable UIImage *)wb_imageByFlipVertical;
/**
 Returns a horizontally flipped image. ⇋
 */
- (nullable UIImage *)wb_imageByFlipHorizontal;
@end
NS_ASSUME_NONNULL_END
