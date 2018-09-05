//
//  WKWebView+WBAdditional.m
//  WBWKWebView
//
//  Created by Mr_Lucky on 2018/8/28.
//  Copyright © 2018年 wenbo. All rights reserved.
//

#import "WKWebView+WBAdditional.h"

@implementation WKWebView (WBAdditional)

- (void)wb_allowsBackForwardNavigationGestures {
    self.allowsBackForwardNavigationGestures = YES;
}

- (void)wb_clearWebCahce {
    if (@available(iOS 9.0, *)) {
        /*  < iOS9及以上 > */
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                             for (WKWebsiteDataRecord *record in records)
                             {
                                 //if ( [record.displayName containsString:@"baidu"]) //取消备注，可以针对某域名做专门的清除，否则是全部清除
                                 //               {
                                 [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                           forDataRecords:@[record]
                                                                        completionHandler:^{
//                                                                            NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                        }];
                                 //               }
                             }
                         }];
    }else {
        /*  < iOS9以下 > */
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath
                                                   error:&errors];
    }
}

- (void)wb_setupCustomUserAgent:(NSString *)customUserAgent {
    __weak typeof(self) weakSelf = self;
    [self evaluateJavaScript:@"navigator.userAgent"
           completionHandler:^(id _Nullable result, NSError * _Nullable error) {
               __strong typeof(self) strongSelf = weakSelf;
               NSString *userAgent = result;
               NSString *newUserAgent = [userAgent stringByAppendingString:customUserAgent];
               [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : newUserAgent}];
               [[NSUserDefaults standardUserDefaults] synchronize];
               strongSelf.customUserAgent = newUserAgent;
           }];
}

@end
