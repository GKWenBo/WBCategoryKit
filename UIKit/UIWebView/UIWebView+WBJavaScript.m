//
//  UIWebView+WBJavaScript.m
//  WBCategories
//
//  Created by Admin on 2018/2/11.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIWebView+WBJavaScript.h"
#import "UIColor+WBWeb.h"

@implementation UIWebView (WBJavaScript)

#pragma mark ------ < Get Web Data > ------
- (int)wb_nodeCountOfTag:(NSString *)tag {
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    int len = [[self stringByEvaluatingJavaScriptFromString:jsString] intValue];
    return len;
}

- (NSString *)wb_getCurrentURL {
    return [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
}

- (NSString *)wb_getTitle {
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSArray *)wb_getImages {
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self wb_nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        [arrImgURL addObject:[self stringByEvaluatingJavaScriptFromString:jsString]];
    }
    return arrImgURL;
}

- (NSArray *)wb_getOnClicks {
    NSMutableArray *arrOnClicks = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self wb_nodeCountOfTag:@"a"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('a')[%d].getAttribute('onclick')", i];
        NSString *clickString = [self stringByEvaluatingJavaScriptFromString:jsString];
        NSLog(@"%@", clickString);
        [arrOnClicks addObject:clickString];
    }
    return arrOnClicks;
}

#pragma mark ------ < Chage Web Style > ------
- (void)wb_setBackgroundColor:(UIColor *)color {
    NSString * jsString = [NSString stringWithFormat:@"document.body.style.backgroundColor = '%@'",[color wb_webColorString]];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

/**  < 为所有图片添加点击事件(网页中有些图片添加无效,需要协议方法配合截取) >  */
- (void)wb_addClickEventOnImg {
    for (int i = 0; i < [self wb_nodeCountOfTag:@"img"]; i++) {
        //利用重定向获取img.src，为区分，给url添加'img:'前缀
        NSString *jsString = [NSString stringWithFormat:
                              @"document.getElementsByTagName('img')[%d].onclick = \
                              function() { document.location.href = 'img' + this.src; }",i];
        [self stringByEvaluatingJavaScriptFromString:jsString];
    }
}

- (void)wb_setImgWidth:(int)size {
    for (int i = 0; i < [self wb_nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].width = '%d'", i, size];
        [self stringByEvaluatingJavaScriptFromString:jsString];
        jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].style.width = '%dpx'", i, size];
        [self stringByEvaluatingJavaScriptFromString:jsString];
    }
}

- (void)wb_setImgHeight:(int)size {
    for (int i = 0; i < [self wb_nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].height = '%d'", i, size];
        [self stringByEvaluatingJavaScriptFromString:jsString];
        jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].style.height = '%dpx'", i, size];
        [self stringByEvaluatingJavaScriptFromString:jsString];
    }
}

- (void)wb_setFontColor:(UIColor *)color withTag:(NSString *)tagName {
    NSString *jsString = [NSString stringWithFormat:
                          @"var nodes = document.getElementsByTagName('%@'); \
                          for(var i=0;i<nodes.length;i++){\
                          nodes[i].style.color = '%@';}", tagName, [color wb_webColorString]];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)wb_setFontSize:(int)size withTag:(NSString *)tagName {
    NSString *jsString = [NSString stringWithFormat:
                          @"var nodes = document.getElementsByTagName('%@'); \
                          for(var i=0;i<nodes.length;i++){\
                          nodes[i].style.fontSize = '%dpx';}", tagName, size];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

#pragma mark ------ < Delete > ------
- (void)wb_deleteNodeByElementID:(NSString *)elementID {
     [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('%@').remove();",elementID]];
}

- (void)wb_deleteNodeByElementClass:(NSString *)elementClass {
    NSString *javaScriptString = [NSString stringWithFormat:@"\
                                  function getElementsByClassName(n) {\
                                  var classElements = [],allElements = document.getElementsByTagName('*');\
                                  for (var i=0; i< allElements.length; i++ )\
                                  {\
                                  if (allElements[i].className == n) {\
                                  classElements[classElements.length] = allElements[i];\
                                  }\
                                  }\
                                  for (var i=0; i<classElements.length; i++) {\
                                  classElements[i].style.display = \"none\";\
                                  }\
                                  }\
                                  getElementsByClassName('%@')",elementClass];
    [self stringByEvaluatingJavaScriptFromString:javaScriptString];
}

- (void)wb_deleteNodeByTagName:(NSString *)elementTagName {
    NSString *javaScritptString = [NSString stringWithFormat:@"document.getElementByTagName('%@').remove();",elementTagName];
    [self stringByEvaluatingJavaScriptFromString:javaScritptString];
}

@end
