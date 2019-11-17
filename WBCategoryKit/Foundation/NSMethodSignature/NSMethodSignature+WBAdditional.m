//
//  NSMethodSignature+WBAdditional.m
//  Pods
//
//  Created by 文波 on 2019/11/17.
//

#import "NSMethodSignature+WBAdditional.h"
#import "WBMacro.h"

@implementation NSMethodSignature (WBAdditional)

- (NSString *)wb_typeString {
    WB_SUPPRESS_PerformSelectorLeak_WARNING(NSString *typeString = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"_%@String", @"type"])];
                                            return typeString;);
}

- (const char *)wb_typeEncoding {
    return self.wb_typeString.UTF8String;
}

@end
