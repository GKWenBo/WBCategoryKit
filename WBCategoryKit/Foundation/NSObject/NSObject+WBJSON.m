//
//  NSObject+WBJSON.m
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "NSObject+WBJSON.h"

@implementation NSObject (WBJSON)
+ (id)wb_objectConvertToJsonSting:(id)object {
    if (![NSJSONSerialization isValidJSONObject:object]) {
        NSAssert(nil, @"不能转换为json",__PRETTY_FUNCTION__);
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil) {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

+ (id)wb_jsonStringToObject:(NSString *)jsonString {
    if ([jsonString isEqualToString:@""]||jsonString == nil||!(jsonString.length > 0)) {
        NSAssert(jsonString != nil, @"jsonString 不能为空",__PRETTY_FUNCTION__);
        return nil;
    }
    
    NSData *data=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [self wb_jsonDataToObject:data];
}

+ (id)wb_jsonDataToObject:(NSData *)jsonData {
    if (jsonData == nil||!(jsonData.length > 0)) {
        NSAssert(jsonData != nil, @"jsonData 不能为空",__PRETTY_FUNCTION__);
        return nil;
    }
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    }
    return nil;
}

+ (NSData *)wb_jsonDataFromString:(NSString *)string {
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *)wb_jsonDataFromObject:(id)object {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:NULL];
    return jsonData;
}

@end
