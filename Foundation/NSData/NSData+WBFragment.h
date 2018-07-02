//
//  NSData+WBFragment.h
//  WBCategories
//
//  Created by wenbo on 2018/7/2.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (WBFragment)

/**
 Data 数据切片

 @param fragmentSize 切片大小，单位：MB
 @return 分片数组
 */
- (NSArray *)wb_cutDataWithFragmentSize:(NSInteger)fragmentSize;

@end
