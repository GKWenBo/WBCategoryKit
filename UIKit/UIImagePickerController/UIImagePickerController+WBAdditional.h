//
//  UIImagePickerController+WBAdditional.h
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (WBAdditional)

#pragma mark ------ < 系统相机相关 > ------
+ (UIImagePickerController *)wb_imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType;

/**
 图库是否可用
 
 @return YES/NO
 */
+ (BOOL)wb_isAvailablePhotoLibrary;

/**
 相机是否可用
 
 @return YES/NO
 */
+ (BOOL)wb_isAvailableCamera;

/**
 是否支持拍照权限
 
 @return YES/NO
 */
+ (BOOL)wb_isSupportTakingPhotos;

/**
 是否支持图库权限
 
 @return YES/NO
 */
+ (BOOL)wb_isSupportPickPhotosFromPhotoLibrary;

/**
 是否支持媒体类型
 
 @param mediaType 媒体类型
 @param sourceType 媒体类型
 @return YES/NO
 */
+ (BOOL)wb_isSupportsMedia:(NSString *)mediaType
                sourceType:(UIImagePickerControllerSourceType)sourceType;

@end
