//
//  NSObject+WBJSON.h
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WBJSON)
/**
 NSArray/NSDictionary转json字符串
 
 @param object NSArray/NSDictionary
 @return json字符串
 */
+ (id)wb_objectConvertToJsonSting:(id)object;

/**
 json字符串转化NSArray/NSDictionary
 
 @param jsonString json字符串
 @return NSArray/NSDictionary
 */
+ (id)wb_jsonStringToObject:(NSString *)jsonString;

/**
 *  json数据转NSArray/NSDictionary
 *
 *  @param jsonData json数据
 *  @return NSArray/NSDictionary
 */
+ (id)wb_jsonDataToObject:(NSData *)jsonData;

/**
 JSON sting convert to data.
 
 @param string JSON string.
 @return data.
 */
+ (NSData *)wb_jsonDataFromString:(NSString *)string;

/**
 Convert object to data.
 
 @param object object.
 @return data.
 */
+ (NSData *)wb_jsonDataFromObject:(id)object;

@end
