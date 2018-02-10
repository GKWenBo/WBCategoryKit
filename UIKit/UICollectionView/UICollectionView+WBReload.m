//
//  UICollectionView+WBReload.m
//  WBCategoryDemo
//
//  Created by Admin on 2017/11/6.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "UICollectionView+WBReload.h"

@implementation UICollectionView (WBReload)

- (void)wb_reloadData {
    [UIView performWithoutAnimation:^{
        [self reloadData];
    }];
}

- (void)wb_reloadSection:(NSInteger)section {
    [UIView performWithoutAnimation:^{
        [self reloadSections:[NSIndexSet indexSetWithIndex:section]];
    }];
}

@end
