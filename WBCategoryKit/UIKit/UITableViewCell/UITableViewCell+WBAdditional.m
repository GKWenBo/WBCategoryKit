//
//  UITableViewCell+WBAdditional.m
//  WBCategories
//
//  Created by Mr_Lucky on 2018/9/5.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UITableViewCell+WBAdditional.h"

@implementation UITableViewCell (WBAdditional)

+ (instancetype)wb_dequeueReusableCellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"kIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identifier];
    }
    return cell;
}

@end
