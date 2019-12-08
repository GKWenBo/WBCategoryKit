//
//  NSCharacterSet+WBAdditional.m
//  Pods
//
//  Created by 文波 on 2019/12/8.
//

#import "NSCharacterSet+WBAdditional.h"

@implementation NSCharacterSet (WBAdditional)

+ (NSCharacterSet *)wb_URLUserInputQueryAllowedCharacterSet {
    NSMutableCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
    [set removeCharactersInString:@"#&="];
    return set.copy;
}

@end
