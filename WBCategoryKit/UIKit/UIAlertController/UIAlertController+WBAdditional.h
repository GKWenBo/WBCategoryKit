//
//  UIAlertController+WBAdditional.h
//  WBCategories
//
//  Created by wenbo on 2018/5/22.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WBAlertActionBlock)(void);
typedef void(^WBAlertClickedBlock)(NSInteger clickedIndex);

@interface UIAlertController (WBAdditional)

/**
 快速创建中间弹出提示框
 
 @param title 标题
 @param message 提示信息
 @param clickedBlock 点击action下标回调
 @param cancelActionString 取消标题
 @param otherActionString 其他按钮标题，example：@“相机”，@“照片”,nil
 */
+ (void)wb_showAlertWithTitle:(NSString *)title
                      message:(NSString *)message
                 clickedBlock:(WBAlertClickedBlock)clickedBlock
           cancelActionString:(NSString *)cancelActionString
            otherActionString:(NSString *)otherActionString, ...;

/**
 快速创建底部弹出提示框
 
 @param title 标题
 @param message 信息
 @param clickedBlock 点击按钮回调
 @param cancelActionString 取消按钮
 @param destructiveActionString 红色按钮
 @param otherActionString 其他按钮标题，example：@“相机”，@“照片”,nil
 */
+ (void)wb_showActionSheetWithTitle:(NSString *)title
                            message:(NSString *)message
                       clickedBlock:(WBAlertClickedBlock)clickedBlock
                 cancelActionString:(NSString *)cancelActionString
            destructiveActionString:(NSString *)destructiveActionString
                  otherActionString:(NSString *)otherActionString, ...;
/**
 提示框，一个按钮
 
 @param title 标题
 @param message 提示信息
 @param actionTitle 按钮标题，传nil，默认‘好的’
 */
+ (void)wb_showOneAlertActionWithTitle:(NSString *)title
                               message:(NSString *)message
                           actionTitle:(NSString *)actionTitle;

/**
 提示框，一个按钮，点击回调block
 
 @param title 标题
 @param message 提示信息
 @param actionTitle 按钮标题，传nil，默认‘好的’
 @param confirmBlock 点击回调block
 */
+ (void)wb_showOneAlertActionWithTitle:(NSString *)title
                               message:(NSString *)message
                           actionTitle:(NSString *)actionTitle
                          confirmBlock:(WBAlertActionBlock)confirmBlock;


/**
 提示框，两个按钮，左边取消，右边确定
 
 @param title 标题
 @param message 提示信息
 @param confirmBlock 点击确定回调block
 */
+ (void)wb_showTwoAlertActionWithTitle:(NSString *)title
                               message:(NSString *)message
                          confirmBlock:(WBAlertActionBlock)confirmBlock;


/**
 中间弹出2s自动消失提示框
 
 @param title 标题
 @param message 提示信息
 */
+ (void)wb_showAutoDismissAlertWithTitle:(NSString *)title
                                 message:(NSString *)message;

/**
 底部弹窗2s自动消失
 
 @param title 标题
 @param message 提示信息
 */
+ (void)wb_showAutoDismissActionSheetWithTitle:(NSString *)title
                                       message:(NSString *)message;


/**
 提示：无相机权限
 */
+ (void)wb_showCameraAuthorizationDeniedAlert;

/**
 提示：无图库访问权限
 */
+ (void)wb_showPhotoLibraryAuthorizationDeniedAlert;

#pragma mark < Basic Method >
+ (void)wb_showOneAlertActionWithTitle:(NSString *)title
                               message:(NSString *)message
                           actionTitle:(NSString *)actionTitle
                           actionBlock:(WBAlertActionBlock)actionBlock;

+ (void)wb_showTwoAlertActionWithTitle:(NSString *)title
                               message:(NSString *)message
                       leftActionTitle:(NSString *)leftActionTitle
                      rightActionTitle:(NSString *)rightActionTitle
                       leftActionBlock:(WBAlertActionBlock)leftActionBlock
                      rightActionBlock:(WBAlertActionBlock)rightActionBlock;

+ (void)wb_showAutoDismissAlertWithTitle:(NSString *)title
                                 message:(NSString *)message
                              afterDelay:(NSTimeInterval)afterDelay;

+ (void)wb_showAutoDismissActionSheetWithTitle:(NSString *)title
                                       message:(NSString *)message
                                    afterDelay:(NSTimeInterval)afterDelay;

@end
