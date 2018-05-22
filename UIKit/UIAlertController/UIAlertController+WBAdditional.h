//
//  UIAlertController+WBAdditional.h
//  WBCategories
//
//  Created by wenbo on 2018/5/22.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertActionBlock)(void);
typedef void(^AlertClickedBlock)(NSInteger clickedIndex);

@interface UIAlertController (WBAdditional)

/**
 快速创建中间弹出提示框
 
 @param title 标题
 @param message 提示信息
 @param clickedBlock 点击action下标回调
 @param cancleActionString 取消标题
 @param otherActionString 其他按钮标题，example：@“相机”，@“照片”,nil
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              clickedBlock:(AlertClickedBlock)clickedBlock
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
+ (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                    clickedBlock:(AlertClickedBlock)clickedBlock
              cancelActionString:(NSString *)cancelActionString
         destructiveActionString:(NSString *)destructiveActionString
               otherActionString:(NSString *)otherActionString, ...;
/**
 提示框，一个按钮
 
 @param title 标题
 @param message 提示信息
 @param actionTitle 按钮标题，传nil，默认‘好的’
 */
+ (void)showOneAlertActionWithTitle:(NSString *)title
                            message:(NSString *)message
                        actionTitle:(NSString *)actionTitle;

/**
 提示框，一个按钮，点击回调block
 
 @param title 标题
 @param message 提示信息
 @param actionTitle 按钮标题，传nil，默认‘好的’
 @param confirmBlock 点击回调block
 */
+ (void)showOneAlertActionWithTitle:(NSString *)title
                            message:(NSString *)message
                        actionTitle:(NSString *)actionTitle
                       confirmBlock:(AlertActionBlock)confirmBlock;


/**
 提示框，两个按钮，左边取消，右边确定
 
 @param title 标题
 @param message 提示信息
 @param confirmBlock 点击确定回调block
 */
+ (void)showTwoAlertActionWithTitle:(NSString *)title
                            message:(NSString *)message
                       confirmBlock:(AlertActionBlock)confirmBlock;


/**
 中间弹出2s自动消失提示框
 
 @param title 标题
 @param message 提示信息
 */
+ (void)showAutoDismissAlertWithTitle:(NSString *)title
                              message:(NSString *)message;

/**
 底部弹窗2s自动消失
 
 @param title 标题
 @param message 提示信息
 */
+ (void)showAutoDismissActionSheetWithTitle:(NSString *)title
                                    message:(NSString *)message;


/**
 提示：无相机权限
 */
+ (void)showCameraAuthorizationDeniedAlert;

/**
 提示：无图库访问权限
 */
+ (void)showPhotoLibraryAuthorizationDeniedAlert;

#pragma mark < Basic Method >
+ (void)showOneAlertActionWithTitle:(NSString *)title
                            message:(NSString *)message
                        actionTitle:(NSString *)actionTitle
                        actionBlock:(AlertActionBlock)actionBlock;

+ (void)showTwoAlertActionWithTitle:(NSString *)title
                            message:(NSString *)message
                    leftActionTitle:(NSString *)leftActionTitle
                   rightActionTitle:(NSString *)rightActionTitle
                    leftActionBlock:(AlertActionBlock)leftActionBlock
                   rightActionBlock:(AlertActionBlock)rightActionBlock;

+ (void)showAutoDismissAlertWithTitle:(NSString *)title
                              message:(NSString *)message
                           afterDelay:(NSTimeInterval)afterDelay;

+ (void)showAutoDismissActionSheetWithTitle:(NSString *)title
                                    message:(NSString *)message
                                 afterDelay:(NSTimeInterval)afterDelay;

@end
