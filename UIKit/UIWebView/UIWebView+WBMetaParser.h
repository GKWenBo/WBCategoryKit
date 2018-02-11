//
//  UIWebView+WBMetaParser.h
//  WBCategories
//
//  Created by Admin on 2018/2/11.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (WBMetaParser)

/**
 Get HTML meta info.
 */
- (NSArray *)wb_getMetaData;

@end
