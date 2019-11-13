//
//  WBClearWarningMacro.h
//  WBCategories
//
//  Created by WMB on 2018/2/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

/** << Clear Project warning. > */

#ifndef WBClearWarningMacro_h
#define WBClearWarningMacro_h

/*
 1、清除警告基本语法
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "警告名称"
 //被夹在这中间的代码针对于此警告都会无视并且不显示出来
 #pragma clang diagnostic pop
 
 2、Example
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wdeprecated-declarations"
 return [@"contentText" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320, CGFLOAT_MAX) lineBreakMode:0];
 #pragma clang diagnostic pop
 
 3、常见编译警告类型
 -Wincompatible-pointer-types    指针类型不匹配
 -Wincomplete-implementation     没有实现已声明的方法
 -Wprotocol                      没有实现协议的方法
 -Wimplicit-function-declaration 尚未声明的函数(通常指c函数)
 -Warc-performSelector-leaks     使用performSelector可能会出现泄漏(该警告在xcode4.3.1中没出现过,网上流传说4.2使用performselector:withObject: 就会得到该警告)
 -Wdeprecated-declarations       使用了不推荐使用的方法(如[UILabel setFont:(UIFont*)])
 -Wunused-variable               含有没有被使用的变量
 -Wundeclared-selector           未定义selector方法
 
 4、忽略cocoapod引入的第三方警告
 pod 'Alamofire', '~> 3.0.0-beta.3', :inhibit_warnings => true
 
 
 */

///PerformSelector警告
#define WB_SUPPRESS_PerformSelectorLeak_WARNING(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

///忽略未定义方法警告
#define  WB_SUPPRESS_Undeclaredselector_WARNING(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

///忽略过期API警告
#define WB_SUPPRESS_DEPRECATED_WARNING(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

///未使用定义
#define WB_SUPPRESS_UNUSEDVALUE_WARNING(Stuff)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wunused-value\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* WBClearWarningMacro_h */
