//
//  UITableViewCell+WBAdditional.h
//  WBCategories
//
//  Created by Mr_Lucky on 2018/9/5.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (WBAdditional)

/**
 Register cell.
 
 @param tableView target tableView.
 @return UITableViewCell.
 */
+ (instancetype)wb_dequeueReusableCellWithTableView:(UITableView *)tableView;

@end
