//
//  UIImagePickerController+WBAdditional.m
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIImagePickerController+WBAdditional.h"
#import "WBDateFormatterPool.h"

@implementation UIImagePickerController (WBAdditional)

// MARK:系统相机相关
+ (UIImagePickerController *)wb_imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    [controller setSourceType:sourceType];
    
    NSMutableArray *mediaTypes = @[].mutableCopy;
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeJPEG];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeJPEG2000];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeTIFF];
    [mediaTypes addObject:(__bridge NSString *)kUTTypePICT];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeGIF];
    [mediaTypes addObject:(__bridge NSString *)kUTTypePNG];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeQuickTimeImage];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeAppleICNS];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeBMP];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeICO];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeRawImage];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeScalableVectorGraphics];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeLivePhoto];
    [controller setMediaTypes:mediaTypes];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
            return NO;
        }else {
            return YES;
        }
    }
#pragma clang diagnostic pop
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

+ (void)wb_compressVideoWithInputURL:(NSURL *)inputURL
                          AVFileType:(AVFileType)outputFileType
                             quality:(NSString *)quality
                      completedBlock:(void (^) (NSURL *outputURL, float process, NSError *error))completedBlock {
    if (!inputURL) return;
    
    /** < 创建路径 > */
    NSString *cahcePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSDateFormatter *dateFormatter = [[WBDateFormatterPool shareInstance] wb_dateFormatterWithFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *strPath = [cahcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@output.mp4",dateStr]];
    NSURL *outputURL = [NSURL fileURLWithPath:strPath];
    
    AVURLAsset *avAsset = [[AVURLAsset alloc]initWithURL:inputURL
                                                 options:nil];
    
    NSArray *exportPresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    /** < 所支持的压缩格式中是否有 所选的压缩格式 > */
    if ([exportPresets containsObject:quality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:quality];
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = outputFileType;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completedBlock) {
                    completedBlock(outputURL,exportSession.progress,exportSession.error);
                }
            });
        }];
    }
}

// MARK:Private Method
+ (BOOL)isiOS8OrLater {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0;
}

@end
