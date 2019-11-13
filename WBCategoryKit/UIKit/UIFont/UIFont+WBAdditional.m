//
//  UIFont+WBAdditional.m
//  Pods-WBCategoryKit_Example
//
//  Created by WenBo on 2019/11/13.
//

#import "UIFont+WBAdditional.h"

@implementation UIFont (WBAdditional)

/// 打印系统字体名称
+ (void)wb_printFontNames {
    NSArray *familyNames = [UIFont familyNames];
   for (NSString *familyName in familyNames) {
       printf("familyNames = %s\n",[familyName UTF8String]);
       
       NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
       
       for (NSString *fontName in fontNames) {
           printf("\tfontName = %s\n",[fontName UTF8String]);
       }
   }
}

@end
