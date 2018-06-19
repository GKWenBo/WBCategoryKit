//
//  UINavigationController+WBFullScreen.h
//  UIViewControllerFullScreenDemo
//
//  Created by WMB on 2017/9/26.
//  Copyright © 2017年 WMB. All rights reserved.
//

/**  < Full Pop Gesture >  */

#import <UIKit/UIKit.h>

@interface UIViewController (WBFullScreen)

/**
 禁止右滑返回属性
 */
@property (nonatomic, assign) BOOL sx_disableInteractivePop;

@end

@interface UINavigationController (WBFullScreen)

@end
