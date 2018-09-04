//
//  NSString+WBJavaScript.h
//  Demo
//
//  Created by Admin on 2017/11/8.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (WBJavaScript)

/**
 Auto fit image height,font size 14pt

 @param htmlString htmlString description
 @return Auto fit htmlString
 */
+ (NSString *)wb_autoFitImageSize:(NSString *)htmlString;
/**
 Auto fit image height,font size

 @param htmlString htmlString description
 @param fontSize The font szie
 @return return value description
 */
+ (NSString *)wb_autoFitImageSize:(NSString *)htmlString
                         fontSize:(CGFloat)fontSize;

/**
 Get disable webView zooming javaScript code

 @return javaScript code
 */
+ (NSString *)wb_getAutoSizeAndDisableWebZoomingJsString;

/**
 Get disable long touch string

 @return javaScript code
 */
+ (NSString *)wb_getDisableLongTouchJsString;

/**
 Get disable user select string

 @return javaScript code
 */
+ (NSString *)wb_getDisableSelectJsString;


@end
