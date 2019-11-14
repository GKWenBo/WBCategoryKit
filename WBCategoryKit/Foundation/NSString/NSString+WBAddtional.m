//
//  NSString+WBAddtional.m
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "NSString+WBAddtional.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+WBDeviceInfo.h"
#import "NSString+WBPredicate.h"

@implementation NSString (WBAddtional)

- (NSString *)wb_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

- (NSString *)wb_capitalizedString {
    if (self.length)
        return [NSString stringWithFormat:@"%@%@", [self substringToIndex:1].uppercaseString, [self substringFromIndex:1]].copy;
    return nil;
}

#pragma mark --------  计算文字大小  --------
- (CGSize)wb_sizeForFont:(UIFont *)font
                    size:(CGSize)size
                    mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)wb_widthForFont:(UIFont *)font {
    return [self wb_sizeForFont:font
                           size:CGSizeMake(HUGE, HUGE)
                           mode:NSLineBreakByWordWrapping].width;
}

- (CGFloat)wb_heightForFont:(UIFont *)font
                      width:(CGFloat)width {
    
    return [self wb_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping].height;
}

#pragma mark --------  隐藏部分文字  --------
+ (NSString *)wb_hidePartCharacterWithNumberStr:(NSString *)number
                                   headerLength:(NSInteger)headerLength
                                   footerLength:(NSInteger)footerLength {
    NSAssert(number.length > headerLength + footerLength, @"数字字符串长度太短");
    if (number.length > headerLength + footerLength) {
        
        NSMutableString * mutableString = [NSMutableString string];
        [mutableString appendString:[number substringToIndex:headerLength]];
        
        for (NSInteger i = 0; i < number.length - (headerLength + footerLength); i ++) {
            [mutableString appendString:@"*"];
        }
        
        [mutableString appendString:[number substringFromIndex:number.length - footerLength]];
        return mutableString;
        
    }else {
        return number;
    }
}

+ (NSString *)wb_disposeIDCardNumber:(NSString *)IDCardNumber {
    //星号字符串
    NSString *xinghaoStr = @"";
    //动态计算星号的个数
    for (int i  = 0; i < IDCardNumber.length - 7; i++) {
        xinghaoStr = [xinghaoStr stringByAppendingString:@"*"];
    }
    //身份证号取前3后四中间以星号拼接
    IDCardNumber = [NSString stringWithFormat:@"%@%@%@",[IDCardNumber substringToIndex:3],xinghaoStr,[IDCardNumber substringFromIndex:IDCardNumber.length-4]];
    //返回处理好的身份证号
    return IDCardNumber;
}

#pragma mark --------  Transform  --------
+ (NSString *)wb_digitUppercaseWithMoney:(NSString *)money {
    NSMutableString *moneyStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[money doubleValue]]];
    NSArray *MyScale= @[@"分",
                        @"角",
                        @"元",
                        @"拾",
                        @"佰",
                        @"仟",
                        @"万",
                        @"拾",
                        @"佰",
                        @"仟",
                        @"亿",
                        @"拾",
                        @"佰",
                        @"仟",
                        @"兆",
                        @"拾",
                        @"佰",
                        @"仟" ];
    NSArray *MyBase= @[@"零",
                       @"壹",
                       @"贰",
                       @"叁",
                       @"肆",
                       @"伍",
                       @"陆",
                       @"柒",
                       @"捌",
                       @"玖"];
    
    NSArray *integerArray = @[@"拾",
                              @"佰",
                              @"仟",
                              @"万",
                              @"拾万",
                              @"佰万",
                              @"仟万",
                              @"亿",
                              @"拾亿",
                              @"佰亿",
                              @"仟亿",
                              @"兆",
                              @"拾兆",
                              @"佰兆",
                              @"仟兆"];
    NSMutableString *M = [[NSMutableString alloc] init];
    [moneyStr deleteCharactersInRange:NSMakeRange([moneyStr rangeOfString:@"."].location, 1)];
    for(NSInteger i = moneyStr.length;i > 0; i--)
    {
        NSInteger MyData=[[moneyStr substringWithRange:NSMakeRange(moneyStr.length-i, 1)] integerValue];
        [M appendString:MyBase[MyData]];
        
        //判断是否是整数金额
        if (i == moneyStr.length) {
            NSInteger l = [[moneyStr substringFromIndex:1] integerValue];
            if (MyData > 0 &&
                l == 0 ) {
                NSString *integerString = @"";
                if (moneyStr.length > 3) {
                    integerString = integerArray[moneyStr.length - 4];
                }
                [M appendString:[NSString stringWithFormat:@"%@%@",integerString, @"元整"]];
                break;
            }
        }
        
        if([[moneyStr substringFromIndex:moneyStr.length-i+1] integerValue] == 0
           && i != 1
           && i != 2)
        {
            [M appendString:@"元整"];
            break;
        }
        [M appendString:MyScale[i-1]];
    }
    return M;
}

- (NSNumber *)wb_numberValue {
    
    return [self wb_numberWithString:self];
}

- (NSData *)wb_dataValue{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)wb_jsonValueDecoded {
    NSData * data = [self wb_dataValue];
    return [self jsonValueDecodedWithData:data];
}

+ (NSString *)wb_formatFloat:(float)floatValue {
    if (fmodf(floatValue, 1) == 0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",floatValue];
    } else if (fmodf(floatValue * 10, 1) == 0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",floatValue];
    } else {
        return [NSString stringWithFormat:@"%.2f",floatValue];
    }
}

+ (NSString *)wb_getFloatFormat:(float)floatValue {
    if (fmodf(floatValue, 1) == 0) {//如果有一位小数点
        return @"%.0f";
    } else if (fmodf(floatValue * 10, 1) == 0) {//如果有两位小数点
        return @"%.1f";
    } else {
        return @"%.2f";
    }
}

+ (NSString *)wb_formattingDoubleValue:(double)doubleValue {
    NSString *dStr = [NSString stringWithFormat:@"%f", doubleValue];
    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
    return dn.stringValue;
}

#pragma mark --------  Common Method  --------
/**
 Returns NSMakeRange(0, self.length).
 */
- (NSRange)wb_rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (NSUInteger)wb_getNeedLinesWithLimitWidth:(CGFloat)width
                                       font:(UIFont *)font {
    //创建一个labe
    UILabel *label = [[UILabel alloc]init];
    //font和当前label保持一致
    label.font = font;
    NSString *text = self;
    NSInteger sum = 0;
    //总行数受换行符影响，所以这里计算总行数，需要用换行符分隔这段文字，然后计算每段文字的行数，相加即是总行数。
    NSArray *splitText = [text componentsSeparatedByString:@"\n"];
    for (NSString *sText in splitText) {
        label.text = sText;
        //获取这段文字一行需要的size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        //size.width/所需要的width 向上取整就是这段文字占的行数
        NSInteger lines = ceilf(textSize.width/width);
        //当是0的时候，说明这是换行，需要按一行算。
        lines = lines == 0 ? 1 : lines;
        sum += lines;
    }
    return sum;
}

#pragma mark --------  Private Method  --------
- (NSNumber *)wb_numberWithString:(NSString *)string  {
    NSString *str = [[string wb_trim] lowercaseString];
    if (!str || !str.length) {
        return nil;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]};
    });
    NSNumber *num = dic[str];
    if (num) {
        if (num == (id)[NSNull null]) return nil;
        return num;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc)
            return [NSNumber numberWithLong:((long)num * sign)];
        else
            return nil;
    }
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

- (id)jsonValueDecodedWithData:(NSData *)data {
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"jsonValueDecoded error:%@", error);
    }
    return value;
}

#pragma mark ------ < File Path > ------
/**
 *  获取Document文件夹
 *  @return Document路径
 */
+ (NSString *)wb_getDocumentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

/**
 *  获取Library/Caches
 *  @return Library/Caches路径
 */
+ (NSString *)wb_getLibraryCaches {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)wb_createFileName {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags  = NSCalendarUnitYear|
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    
    NSDateComponents* dayComponents = [calendar components:(unitFlags) fromDate:date];
    NSUInteger year = [dayComponents year];
    NSUInteger month =  [dayComponents month];
    NSUInteger day =  [dayComponents day];
    NSInteger hour =  [dayComponents hour];
    NSInteger minute =  [dayComponents minute];
    double second = [dayComponents second];
    
    NSString *strMonth;
    NSString *strDay;
    NSString *strHour;
    NSString *strMinute;
    NSString *strSecond;
    if (month < 10) {
        strMonth = [NSString stringWithFormat:@"0%lu",(unsigned long)month];
    }
    else {
        strMonth = [NSString stringWithFormat:@"%lu",(unsigned long)month];
    }
    //NSLog(@"%@",strMonth.description);
    if (day < 10) {
        strDay = [NSString stringWithFormat:@"0%lu",(unsigned long)day];
    }
    else {
        strDay = [NSString stringWithFormat:@"%lu",(unsigned long)day];
    }
    
    if (hour < 10) {
        strHour = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    else {
        strHour = [NSString stringWithFormat:@"%ld",(long)hour];
    }
    
    if (minute < 10) {
        strMinute = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
    else {
        strMinute = [NSString stringWithFormat:@"%ld",(long)minute];
    }
    
    if (second < 10) {
        strSecond = [NSString stringWithFormat:@"0%0.f",second];
    }
    else {
        strSecond = [NSString stringWithFormat:@"%0.f",second];
    }
    
    NSString *str = [NSString stringWithFormat:@"%ld%@%@%@%@%@%@",
                     (unsigned long)year,strMonth,strDay,strHour,strMinute,strSecond,[NSString wb_stringWithUUID]];
    return str;
}

@end
