//
//  WBFontMacro.h
//  Demo
//
//  Created by Admin on 2017/11/22.
//  Copyright © 2017年 文波. All rights reserved.
//

#ifndef WBFontMacro_h
#define WBFontMacro_h

/**  < 设置平方字体PingFangSC >  */
///苹方字体常规
#define WBPFR_FONT_SIZE(s) [UIFont fontWithName:@"PingFangSC-Regular" size:s]
///苹方字体中等
#define WBPFM_FONT_SIZE(s) [UIFont fontWithName:@"PingFangSC-Medium" size:s]
///平方字体粗体
#define WBPFB_FONT_SIZE(s) [UIFont fontWithName:@"PingFangSC-Semibold" size:s]
///系统字体
#define WBSYS_FONT_SIZE(s) [UIFont systemFontOfSize:s]
///系统字体加粗
#define WBSYSB_FONT_SIZE(s) [UIFont boldSystemFontOfSize:s]

#endif /* WBFontMacro_h */
