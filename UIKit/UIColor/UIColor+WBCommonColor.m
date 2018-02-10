//
//  UIColor+WB_CommonColor.m
//  UIColorUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIColor+WBCommonColor.h"
#import "UIColor+WBAdditional.h"
@implementation UIColor (WBCommonColor)

#pragma mark --------  Custom Color  --------
#pragma mark
+ (UIColor *)wb_sepratorColor {
    return [UIColor wb_colorWithHexString:@"eeeeee"];
}
+ (UIColor *)wb_skyBlueColor {
    return [UIColor wb_rgbColorWithRed:135.f green:206.f blue:235.f];
}
/** 金黄色 */
+ (UIColor *)wb_goldenYellowColor {
    return [UIColor wb_rgbColorWithRed:255.f green:215.f blue:0.f];
}
/** 巧克力色 */
+ (UIColor *)wb_chocolateColor {
    return [UIColor wb_rgbColorWithRed:210.f green:105.f blue:30.f];
}
/** 印度红 */
+ (UIColor *)wb_IndiaRedColor {
    return [UIColor wb_rgbColorWithRed:176.f green:23.f blue:31.f];
}
/** 栗色 */
+ (UIColor *)wb_marronColor {
    return [UIColor wb_rgbColorWithRed:176.f green:48.f blue:96.f];
}
/** 草莓色 */
+ (UIColor *)wb_strawberryColor {
    return [UIColor wb_rgbColorWithRed:135.f green:38.f blue:87.f];
}
/** 番茄色 */
+ (UIColor *)wb_tomatoColor {
    return [UIColor wb_rgbColorWithRed:255.f green:99.f blue:71.f];
}
/** 深红色 */
+ (UIColor *)wb_deepRedColor {
    return [UIColor wb_rgbColorWithRed:255.f green:0.f blue:255.f];
}
/** 孔雀蓝 */
+ (UIColor *)wb_peacockBlueColor {
    return [UIColor wb_rgbColorWithRed:51.f green:161.f blue:201.f];
}
/** 紫罗兰色 */
+ (UIColor *)wb_violetColor {
    return [UIColor wb_rgbColorWithRed:138.f green:43.f blue:226.f];
}
/** 黄褐色 */
+ (UIColor *)wb_tawnyColor {
    return [UIColor wb_rgbColorWithRed:240.f green:230.f blue:140.f];
}
/** 淡黄色 */
+ (UIColor *)wb_jasmineColor {
    return [UIColor wb_rgbColorWithRed:245.f green:222.f blue:179.f];
}
/** 蛋壳色 */
+ (UIColor *)wb_eggShellColor
{
    return [UIColor wb_rgbColorWithRed:252.f green:230.f blue:201.f];
}
@end
