//
//  WKWebView+WBMetaParser.m
//  WBWKWebView
//
//  Created by Mr_Lucky on 2018/8/28.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WKWebView+WBMetaParser.h"

@implementation WKWebView (WBMetaParser)

- (void)wb_getMetaData:(void (^) (NSArray *metaData))completed {
    [self evaluateJavaScript:@""
    "var json = '[';                                    "
    "var a = document.getElementsByTagName('meta');     "
    "for(var i=0;i<a.length;i++){                       "
    "   json += '{';                                    "
    "   var b = a[i].attributes;                        "
    "   for(var j=0;j<b.length;j++){                    "
    "       var name = b[j].name;                       "
    "       var value = b[j].value;                     "
    "                                                   "
    "       json += '\"'+name+'\":';                    "
    "       json += '\"'+value+'\"';                    "
    "       if(b.length>j+1){                           "
    "           json += ',';                            "
    "       }                                           "
    "   }                                               "
    "   json += '}';                                    "
    "   if(a.length>i+1){                               "
    "       json += ',';                                "
    "   }                                               "
    "}                                                  "
    "json += ']';                                       " completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *errorInfo = nil;
        id array = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingAllowFragments
                                                     error:&errorInfo];
        if(array == nil) NSLog(@"An error occured in meta parser.");
        if (completed) {
            completed(array);
        }
    }];
}

@end
