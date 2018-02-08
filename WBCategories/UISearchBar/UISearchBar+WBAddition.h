//
//  UISearchBar+WBAddition.h
//  JulyGame
//
//  Created by Admin on 2018/2/7.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (WBAddition)

/**
 Get search textField.

 @return UITextField
 */
- (UITextField *)wb_searchField;

/**
 Get searchbar placeholderLabel.

 @return UILabel.
 */
- (UILabel *)wb_placeholderLabel;

/**
 SearchTextField leftView 🔍.

 @return UIImageView
 */
- (UIImageView *)wb_leftSearchIcon;

/**
 Get cancel button on iOS11.

 @return UIButton
 */
- (UIButton *)cancelBtn;

/**
 Get textField cleanButton.

 @return UIButton
 */
- (UIButton *)wb_clearBtn;

/**
 Set cancel button title.

 @param title title string.
 */
- (void)wb_setCancelBtnTitle:(NSString *)title;

/**
 Set cancel button color.

 @param color color description
 */
- (void)wb_setCancelBtnColor:(UIColor *)color;

/**
 Set cancel button font.

 @param font font
 */
- (void)wb_setCancelBtnFont:(UIFont *)font;

/**
 Set 🔍 color.

 @param color color description
 */
- (void)wb_changeSearchIconColor:(UIColor *)color;

/**
 Clear searcg border.
 */
- (void)wb_clearShadowBorder;

/**
 Custom search icon.

 @param imageName imageName
 */
- (void)wb_setSearchIconWithImageName:(NSString *)imageName;

/**
 Set searchTextField text color.

 @param color color
 */
- (void)wb_setSearchTextColor:(UIColor *)color;

@end
