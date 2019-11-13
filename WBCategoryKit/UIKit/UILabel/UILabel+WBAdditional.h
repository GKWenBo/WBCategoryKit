//
//  UILabel+WBAdditional.h
//  Pods-WBCategoryKit_Example
//
//  Created by WenBo on 2019/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (WBAdditional)

@property (nonatomic) NSString *wb_verticalText;

/// 初始化方法
/// @param font 字体大小
/// @param textColor 字体颜色
- (instancetype)wb_initWithFont:(nullable UIFont *)font
                      textColor:(nullable UIColor *)textColor;
/// 让文本两端对齐
- (void)wb_changeAligmentLeftAndRight;

@end

NS_ASSUME_NONNULL_END
