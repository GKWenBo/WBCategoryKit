//
//  UIWebView+WBJavaScript.h
//  WBCategories
//
//  Created by Admin on 2018/2/11.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (WBJavaScript)

#pragma mark ------ < Get Web Data > ------

/**
 获取某个标签的结点个数

 @param tag 标签
 @return 节点个数
 */
- (int)wb_nodeCountOfTag:(NSString *)tag;

/**
 获取当前页面URL

 @return url
 */
- (NSString *)wb_getCurrentURL;

/**
 Get web title

 @return title
 */
- (NSString *)wb_getTitle;

/**
 Get all images in web.

 @return image array
 */
- (NSArray *)wb_getImages;

/**
 Get current page all links.

 @return links
 */
- (NSArray *)wb_getOnClicks;

#pragma mark ------ < Chage Web Style > ------
/**
 Set web background color

 @param color 颜色
 */
- (void)wb_setBackgroundColor:(UIColor *)color;

/**
 Add click event on image,some may be no use.
 */
- (void)wb_addClickEventOnImg;

/**
 Change all imageView width.

 @param size width
 */
- (void)wb_setImgWidth:(int)size;

/**
 Chage all imageView height

 @param size height
 */
- (void)wb_setImgHeight:(int)size;

/**
 Change tag color

 @param color custom color.
 @param tagName tag'name
 */
- (void)wb_setFontColor:(UIColor *)color
                withTag:(NSString *)tagName;

/**
 Change tag font size

 @param size size
 @param tagName tagName
 */
- (void)wb_setFontSize:(int) size
               withTag:(NSString *)tagName;

#pragma mark ------ < Delete > ------

/**
 根据 ElementsID 删除WebView 中的节点

 @param elementID elementID description
 */
- (void )wb_deleteNodeByElementID:(NSString *)elementID;

/**
 根据 ElementsClass 删除 WebView 中的节点

 @param elementClass elementClass description
 */
- (void )wb_deleteNodeByElementClass:(NSString *)elementClass;

/**
 根据  TagName 删除 WebView 的节点

 @param elementTagName elementTagName description
 */
- (void)wb_deleteNodeByTagName:(NSString *)elementTagName;

@end
