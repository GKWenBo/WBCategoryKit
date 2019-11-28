//
//  NSMethodSignature+WBAdditional.m
//  Pods
//
//  Created by 文波 on 2019/11/17.
//

#import "NSMethodSignature+WBAdditional.h"
#import "WBCategoryKitCore.h"

@implementation NSMethodSignature (WBAdditional)

- (NSString *)wb_typeString {
WBBeginIgnorePerformSelectorLeaksWarning
    NSString *typeString = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"_%@String", @"type"])];
WBEndIgnorePerformSelectorLeaksWarning
    return typeString;
}

- (const char *)wb_typeEncoding {
    return self.wb_typeString.UTF8String;
}

@end
