//
//  UIColor+WBWeb.h
//  WBCategories
//
//  Created by Admin on 2018/2/11.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WBWeb)

/**
 Get canvas color string.

 @return NSString
 */
- (NSString *)wb_canvasColorString;

/**
 Get web color string.

 @return NSString
 */
- (NSString *)wb_webColorString;

@end
