//
//  UIWebView+WBKeyValueStorage.h
//  WBCategories
//
//  Created by Admin on 2018/2/11.
//  Copyright © 2018年 WENBO. All rights reserved.
//

/**  <
 GitHub：https://github.com/cprime/UIWebView-WebStorage
 Author：cprime
 >  */

#import <UIKit/UIKit.h>

@interface UIWebView (WBKeyValueStorage)

#pragma mark - Local Storage

- (void)setLocalStorageString:(NSString *)string forKey:(NSString *)key;

- (NSString *)localStorageStringForKey:(NSString *)key;

- (void)removeLocalStorageStringForKey:(NSString *)key;

- (void)clearLocalStorage;

#pragma mark - Session Storage

- (void)setSessionStorageString:(NSString *)string forKey:(NSString *)key;

- (NSString *)sessionStorageStringForKey:(NSString *)key;

- (void)removeSessionStorageStringForKey:(NSString *)key;

- (void)clearSessionStorage;

@end
