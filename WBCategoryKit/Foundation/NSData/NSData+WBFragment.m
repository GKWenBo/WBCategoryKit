//
//  NSData+WBFragment.m
//  WBCategories
//
//  Created by wenbo on 2018/7/2.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "NSData+WBFragment.h"

@implementation NSData (WBFragment)

- (NSArray *)wb_cutDataWithFragmentSize:(NSInteger)fragmentSize {
    if (self.length == 0) return nil;
    
    NSMutableArray *tempArray = @[].mutableCopy;
    NSInteger allLength = self.length;
    NSInteger index = 0;
    do {
        if (allLength > fragmentSize) {
            NSRange range = NSMakeRange(index * fragmentSize * (1000 * 1000), allLength);
            NSData *data = [self subdataWithRange:range];
            [tempArray addObject:data];
            
            index ++;
            allLength = allLength - fragmentSize * (1000 * 1000);
        }else {
            NSRange range = NSMakeRange(index * fragmentSize * (1000 * 1000), allLength);
            NSData *data = [self subdataWithRange:range];
            [tempArray addObject:data];
            allLength = 0;
        }
    } while (allLength > 0);
    
    return tempArray.copy;
}

@end
