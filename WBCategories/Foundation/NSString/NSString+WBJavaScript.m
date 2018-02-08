//
//  NSString+WBJavaScript.m
//  Demo
//
//  Created by Admin on 2017/11/8.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "NSString+WBJavaScript.h"

@implementation NSString (WBJavaScript)

+ (NSString *)wb_autoFitImageSize:(NSString *)htmlString {
    return [self wb_autoFitImageSize:htmlString fontSize:14.f];
}

+ (NSString *)wb_autoFitImageSize:(NSString *)htmlString
                         fontSize:(CGFloat)fontSize {
    return [NSString stringWithFormat:@"<html> \n"
            "<head> \n"
            "<style type=\"text/css\"> \n"
            "body {font-size:%fpx;}\n"
            "</style> \n"
            "</head> \n"
            "<body>"
            "<script type='text/javascript'>"
            "window.onload = function(){\n"
            "var $img = document.getElementsByTagName('img');\n"
            "for(var p in  $img){\n"
            " $img[p].style.width = '100%%';\n"
            "$img[p].style.height ='auto'\n"
            "}\n"
            "}"
            "</script>%@"
            "</body>"
            "</html>",fontSize,htmlString];
}

+ (NSString *)wb_getAutoSizeAndDisableWebZoomingJsString {
    return @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
}

+ (NSString *)wb_getDisableLongTouchJsString {
    return @"document.documentElement.style.webkitTouchCallout='none';";
}

+ (NSString *)wb_getDisableSelectJsString {
    return @"document.documentElement.style.webkitUserSelect='none';";
}

//- (NSString *)wb_autoFitHTMLString {
//    return [NSString stringWithFormat:@"<html> \n"
//            "<head> \n"
//            "<style type=\"text/css\"> \n"
//            "body {font-size:14px;}\n"
//            "</style> \n"
//            "</head> \n"
//            "<body>"
//            "<script type='text/javascript'>"
//            "window.onload = function(){\n"
//            "var $img = document.getElementsByTagName('img');\n"
//            "for(var p in  $img){\n"
//            " $img[p].style.width = '100%%';\n"
//            "$img[p].style.height ='auto'\n"
//            "}\n"
//            "}"
//            "</script>%@"
//            "</body>"
//            "</html>",self];
//}

@end
