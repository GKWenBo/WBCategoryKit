//
//  UIScreen+WBFrame.h
//  WBCategories
//
//  Created by WMB on 2018/2/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (WBFrame)

/**
 Get screen size.

 @return CGSize
 */
+ (CGSize)wb_size;

/**
 Get screen height.

 @return CGFloat
 */
+ (CGFloat)wb_height;

/**
 Get screen width.

 @return CGFloat.
 */
+ (CGFloat)wb_width;

/**
 Get orientation size.

 @return Landscape or Portrait size.
 */
+ (CGSize)wb_orientationSize;

/**
 Get orientation width.

 @return Landscape or Portrait width.
 */
+ (CGFloat)wb_orientationWidth;

/**
  Get orientation height.

 @return  Landscape or Portrait height.
 */
+ (CGFloat)wb_orientationHeight;

+ (CGSize)wb_DPISize;

@end
