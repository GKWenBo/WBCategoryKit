//
//  WB_DateHeaderFile.h
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//


/*
 G: 公元时代，例如AD公元
 
 yy: 年的后2位
 
 yyyy: 完整年
 
 MM: 月，显示为1-12
 
 MMM: 月，显示为英文月份简写,如 Jan
 
 MMMM: 月，显示为英文月份全称，如 Janualy
 
 dd: 日，2位数表示，如02
 
 d: 日，1-2位显示，如2
 
 EEE: 简写星期几，如Sun
 
 EEEE: 全写星期几，如Sunday
 
 ZZZ 时区
 
 aa: 上下午，AM/PM
 
 H: 时，24小时制，0-23
 
 K：时，12小时制，0-11
 
 m: 分，1-2位
 
 mm: 分，2位
 
 s: 秒，1-2位
 
 ss: 秒，2位
 
 S: 毫秒
 
 
 常用日期结构：
 
 yyyy-MM-dd HH:mm:ss.SSS
 
 yyyy-MM-dd HH:mm:ss
 
 yyyy-MM-dd
 
 MM dd yyyy
 */

#import <Foundation/Foundation.h>

#define WB_DateFormat          @"yyyy MM dd HH mm ss"
#define WB_CustomDateFormat    @"yyyy-MM-dd HH:mm:ss"
#define WB_DayFormat           @"yyyy MM dd"
#define WB_DayPointFormat      @"yyyy.MM.dd"
#define WB_DayFormatLine       @"yyyy-MM-dd"
#define WB_ShortTime           @"MM-dd HH:mm"
#define WB_SinaDateFormat      @"yyyy MMM d EEE HH:mm:ss ZZZ"
#define WB_YkmDateFormat       @"yyyyMMddHHmmss"



