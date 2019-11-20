//
//  UISearchBar+WBAddition.h
//  JulyGame
//
//  Created by Admin on 2018/2/7.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
提供更丰富的接口来修改 UISearchBar 的样式，注意大部分接口都同时支持配置表和 UIAppearance，如果有使用配置表并且该项的值不为 nil，则以配置表的值为准。
*/

@interface UISearchBar (WBAddition)

/**
 当以 tableHeaderView 的方式使用 UISearchBar 时，建议将这个属性置为 YES，从而可以帮你处理 https://github.com/Tencent/QMUI_iOS/issues/233 里列出的问题（抖动、iPhone X 适配等），默认为 NO
 */
@property(nonatomic, assign) BOOL wb_usedAsTableHeaderView;

/// 输入框内 placeholder 的颜色
@property(nullable, nonatomic, strong) UIColor *wb_placeholderColor UI_APPEARANCE_SELECTOR;

/// 输入框的文字颜色
@property(nullable, nonatomic, strong) UIColor *wb_textColor UI_APPEARANCE_SELECTOR;

/// 输入框的文字字体，会同时影响 placeholder 的字体
@property(nullable, nonatomic, strong) UIFont *wb_font UI_APPEARANCE_SELECTOR;

/// 输入框相对于系统原有布局位置的上下左右的偏移，正值表示向内缩小，负值表示向外扩大
@property(nonatomic, assign) UIEdgeInsets wb_textFieldMargins UI_APPEARANCE_SELECTOR;

@property(nullable, nonatomic, weak, readonly) UITextField *wb_textField;

/// 获取 searchBar 的背景 view，为一个 UIImageView 的子类 UISearchBarBackground，在 searchBar 初始化完即可被获取
@property(nullable, nonatomic, weak, readonly) UIView *wb_backgroundView;

/// 获取 searchBar 内的取消按钮，注意 UISearchBar 的取消按钮是在 setShowsCancelButton:animated: 被调用之后才会生成
@property(nullable, nonatomic, weak, readonly) UIButton *wb_cancelButton;

/// 取消按钮的字体，由于系统的 cancelButton 是懒加载的，所以当不存在 cancelButton 时该值为 nil
@property(nullable, nonatomic, strong) UIFont *wb_cancelButtonFont UI_APPEARANCE_SELECTOR;

/// 获取 scopeBar 里的 UISegmentedControl
@property(nullable, nonatomic, weak, readonly) UISegmentedControl *wb_segmentedControl;

/// 生成指定颜色的搜索框输入框背景图，大小与系统默认的保持一致，只是颜色不同
+ (nullable UIImage *)wb_generateTextFieldBackgroundImageWithColor:(nullable UIColor *)color;

/// 生成指定背景色和底部边框颜色的搜索框背景图
+ (nullable UIImage *)wb_generateBackgroundImageWithColor:(nullable UIColor *)backgroundColor
                                              borderColor:(nullable UIColor *)borderColor;

@end
NS_ASSUME_NONNULL_END
