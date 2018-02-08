//
//  UITableView+WBiOS7Style.h
//  WBCategories
//
//  Created by WMB on 2018/2/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (WBiOS7Style)

/**
 *  @brief  ios7设置页面的UITableViewCell样式
 *
 *  @param cell      cell
 *  @param indexPath indexPath
 */
- (void)wb_applyiOS7SettingsStyleGrouping:(UITableViewCell *)cell
                       forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
