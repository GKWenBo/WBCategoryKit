//
//  NSString+WBCreateFileName.h
//  WBCategories
//
//  Created by Admin on 2018/2/10.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WBCreateFileName)

/**
 Create upload file name.

 @return random string.
 */
- (NSString *)wb_createFileName;

@end
