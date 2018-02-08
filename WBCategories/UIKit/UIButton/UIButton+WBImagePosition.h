//
//  UIButton+WBImagePosition.h
//  WBCategories
//
//  Created by WMB on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBImagePosition) {
    WBImagePositionLeft = 0,              //图片在左，文字在右，默认
    WBImagePositionRight = 1,             //图片在右，文字在左
    WBImagePositionTop = 2,               //图片在上，文字在下
    WBImagePositionBottom = 3,            //图片在下，文字在上
};

@interface UIButton (WBImagePosition)

/**
 利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing

 @param position image pisition
 @param spacing image & title distance
 */
- (void)wb_setImagePosition:(WBImagePosition)position
                    spacing:(CGFloat)spacing;

@end
