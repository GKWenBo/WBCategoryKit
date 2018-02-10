//
//  UICollectionView+WBReload.h
//  WBCategoryDemo
//
//  Created by Admin on 2017/11/6.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (WBReload)

/**
 解决刷新闪烁问题
 */
- (void)wb_reloadData;
/**
 解决刷新闪烁问题

 @param section 组
 */
- (void)wb_reloadSection:(NSInteger)section;

@end
