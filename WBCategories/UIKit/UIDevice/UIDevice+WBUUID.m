//
//  UIDevice+WBUUID.m
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIDevice+WBUUID.h"
#import "WBUUID.h"

@implementation UIDevice (WBUUID)

- (NSString *)wb_uuid {
    return [WBUUID uuidForDevice];
}

@end
