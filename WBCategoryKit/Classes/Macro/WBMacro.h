//
//  WBMacro.h
//  WBCategories
//
//  Created by Mr_Lucky on 2018/9/5.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<WBCategoryKit/WBCategoryKit.h>)

#import <WBCategoryKit/WBMacroDefinition.h>
#import <WBCategoryKit/WBFontMacro.h>
#import <WBCategoryKit/WBSingletonMacro.h>
#import <WBCategoryKit/WBClearWarningMacro.h>

#else

#import "WBMacroDefinition.h"
#import "WBFontMacro.h"
#import "WBSingletonMacro.h"
#import "WBClearWarningMacro.h"

#endif
