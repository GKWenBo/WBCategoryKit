//
//  NSMutableArray+WBSort.h
//  Demo
//
//  Created by Admin on 2017/10/9.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WBSort)

/**
 选择排序
 */
- (void)wb_selectionSort;

/**
 冒泡排序
 */
- (void)wb_bubbleSort;

/**
 插入排序
 */
- (void)wb_insertionSort;

/**
 快速排序

 @param low low description
 @param high high description
 */
- (void)wb_quickSortWithLowIndex:(NSInteger)low
                       highIndex:(NSInteger)high;

@end
