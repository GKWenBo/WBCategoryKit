//
//  UISearchBar+WBAddition.m
//  JulyGame
//
//  Created by Admin on 2018/2/7.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UISearchBar+WBAddition.h"

@implementation UISearchBar (WBAddition)

- (UITextField *)wb_searchField {
    UITextField *textFiled = [self valueForKey:@"_searchField"];
    if (textFiled) {
        return textFiled;
    }else {
        return nil;
    }
}

- (UILabel *)wb_placeholderLabel {
    UILabel *label = [self valueForKey:@"_placeholderLabel"];
    if (label) {
        return label;
    }else {
        return nil;
    }
}

- (UIImageView *)wb_leftSearchIcon {
    return (UIImageView *)[self wb_searchField].leftView;
}

- (void)wb_setCancelBtnTitle:(NSString *)title {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:title];
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:title];
#pragma clang diagnostic pop
       
    }
}

- (UIButton *)cancelBtn {
    UIButton *button = [self valueForKey:@"_cancelButton"];
    if (button) {
        return button;
    }else {
        return nil;
    }
}

- (void)wb_setCancelBtnColor:(UIColor *)color {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName : color} forState:UIControlStateNormal];
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName : color} forState:UIControlStateNormal];
#pragma clang diagnostic pop
    }
}

- (void)wb_setCancelBtnFont:(UIFont *)font {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSFontAttributeName : font} forState:UIControlStateNormal];
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSFontAttributeName : font} forState:UIControlStateNormal];
#pragma clang diagnostic pop
    }
}

- (void)wb_changeSearchIconColor:(UIColor *)color {
    UIImageView *imageView = [self wb_leftSearchIcon];
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.tintColor = color;
}

- (UIButton *)wb_clearBtn {
    UIButton *button = [self valueForKey:@"_clearButton"];
    if (button) {
        return button;
    }else {
        return nil;
    }
}

- (void)wb_clearShadowBorder {
    [self setBackgroundImage:[UIImage new]];
}

- (void)wb_setSearchIconWithImageName:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

- (void)wb_setSearchTextColor:(UIColor *)color {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].textColor = color;
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].textColor = color;
#pragma clang diagnostic pop
    }
}

@end
