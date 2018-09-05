//
//  UIImagePickerController+WBAdditional.h
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImagePickerController (WBAdditional)

// MARK:Public Method
+ (UIImagePickerController *)wb_imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType;

// MARK:权限判断
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
+ (BOOL)wb_isCameraAuthorized;

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

/**
 是否有图库权限

 @return YES/NO
 */
+ (BOOL)wb_isPhotoLibraryAuthorized;


// MARK:Picker Video
/**
 原生视频拾取

 @return UIImagePickerController.
 */
+ (UIImagePickerController *)wb_pickerVideoController;

/**
 视频录制

 @param videoQuality 录制视频质量
 @param cameraFlashMode 设置闪光灯模式
 @param showsCameraControls 是否需要默认UI
 @param videoMaximumDuration 最大录制时长
 @return UIImagePickerController.
 */
+ (UIImagePickerController *)wb_recordVideoWithVideoQuality:(UIImagePickerControllerQualityType)videoQuality
                                            cameraFlashMode:(UIImagePickerControllerCameraFlashMode)cameraFlashMode
                                        showsCameraControls:(BOOL)showsCameraControls
                                       videoMaximumDuration:(CGFloat)videoMaximumDuration;

/**
 视频压缩，转格式

 @param inputURL 视频源路径
 @param outputFileType 输出格式
 @param quality 压缩质量
 @param completedBlock 完成回调
 */
+ (void)wb_compressVideoWithInputURL:(NSURL *)inputURL
                          AVFileType:(AVFileType)outputFileType
                             quality:(NSString *)quality
                      completedBlock:(void (^) (NSURL *outputURL, float process, NSError *error))completedBlock;

@end
