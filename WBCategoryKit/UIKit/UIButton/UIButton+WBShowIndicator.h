//
//  UIButton+WBShowIndicator.h
//  WBCategories
//
//  Created by WMB on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WBShowIndicator)

/**
 This method will show the activity indicator in place of the button text.
 */
- (void)wb_showIndicator;

/**
 This method will remove the indicator and put thebutton text back in place.
 */
- (void)wb_hideIndicator;

@end
