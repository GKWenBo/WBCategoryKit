//
//  UIImagePickerController+WBAdditional.m
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIImagePickerController+WBAdditional.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImagePickerController (WBAdditional)

#pragma mark ------ < 系统相机相关 > ------
#pragma mark
+ (UIImagePickerController *)wb_imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    [controller setSourceType:sourceType];
    [controller setMediaTypes:@[(NSString *)kUTTypeImage]];
    return controller;
}

+ (BOOL)wb_isAvailablePhotoLibrary {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)wb_isAvailableCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)wb_isCameraAuthorized {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }else {
        return YES;
    }
}

+ (BOOL)wb_isSupportPickPhotosFromPhotoLibrary {
    return [self wb_isSupportsMedia:(__bridge NSString *)kUTTypeImage
                         sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)wb_isPhotoLibraryAuthorized {
    if ([self isiOS8OrLater]) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusDenied) {
            return NO;
        }else {
            return YES;
        }
    }else {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
            return NO;
        }else {
            return YES;
        }
    }
}

+ (BOOL)wb_isSupportsMedia:(NSString *)mediaType
                sourceType:(UIImagePickerControllerSourceType)sourceType {
    __block BOOL result = NO;
    if ([mediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:mediaType]){
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

#pragma mark < Private Method >
+ (BOOL)isiOS8OrLater {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0;
}

@end
