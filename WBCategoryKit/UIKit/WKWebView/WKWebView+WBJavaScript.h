//
//  WKWebView+WBJavaScript.h
//  WBWKWebView
//
//  Created by Mr_Lucky on 2018/8/28.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (WBJavaScript)

// MARK:获取网页元素
/**
 获取某个标签的结点个数

 @param tag 节点名
 @param completedHandler 结果回调
 */
- (void)wb_nodeCountOfTag:(NSString *)tag
         completedHandler:(void (^) (int tagCount))completedHandler;

/**
 获取当前页面URL

 @param completedHandler 结果回调
 */
- (void)wb_getCurrentURL:(void (^) (NSString *url))completedHandler;

/**
 获取当前网页标题

 @param completedHandler 结果回调
 */
- (void)wb_getCurrentTitle:(void (^) (NSString *title))completedHandler;

/**
 获取网页中的图片

 @param completedHandler 结果回调
 */
- (void)wb_getImages:(void (^) (NSArray *images))completedHandler;

/**
 获取网页内容高度

 @param completedHandler callback.
 */
- (void)wb_getScrollHeight:(void (^) (CGFloat scrollHeight))completedHandler;

/**
 获取网页offsetHeight

 @param completedHandler callback.
 */
- (void)wb_getOffsetHeight:(void (^) (CGFloat offsetHeight))completedHandler;

/**
 Get web cookies.

 @param completedHandler callback.
 */
- (void)wb_getCookieString:(void (^) (NSString *cookieString))completedHandler;

/**
 Get long press image url.

 @param touchPoint touch point.
 @param completedHandler callback.
 */
- (void)wb_getLongPressImageUrlWithPoint:(CGPoint)touchPoint
                        completedHandler:(void (^) (NSString *imageUrl))completedHandler;

// MARK:Setup

/**
 Change font size.

 @param fontSize 文字大小
 */
- (void)wb_chnageFontSize:(int)fontSize;

/**
 Change tag font size
 
 @param fontSize size
 @param tagName tagName
 */
- (void)wb_setFontSize:(int)fontSize
               withTag:(NSString *)tagName;

/**
 设置网页背景颜色

 @param color 背景颜色
 */
- (void)wb_setWebBackgroudColor:(UIColor *)color;

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
 为所有图片添加点击事件(网页中有些图片添加无效,需要协议方法配合截取)
 */
- (void)wb_addClickEventOnImg;

/**
 根据id隐藏网页元素

 @param idString id名
 */
- (void)wb_hiddenElementById:(NSString *)idString;

/**
 隐藏指定类名元素

 @param className 类名
 */
- (void)wb_hiddenElementByClassName:(NSString *)className;

/**
 禁止长按
 */
- (void)wb_disableLongTouch;

/**
 禁止选中
 */
- (void)wb_disableSelected;

// MARK:Delete
/**
根据 ElementsID 删除WebView 中的节点

 @param elementID 要删除的节点
 */
- (void)wb_deleteNodeByElementID:(NSString *)elementID;

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


@interface UIColor (WBWebColor)

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
