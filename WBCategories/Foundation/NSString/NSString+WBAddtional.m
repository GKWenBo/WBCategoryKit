//
//  NSString+WBAddtional.m
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "NSString+WBAddtional.h"
#import "NSString+WBPredicate.h"
@implementation NSString (WBAddtional)
#pragma mark --------  计算文字大小  --------
#pragma mark
/**
 *  计算文字size
 *
 *  @param size 限制size
 *  @param font 字体
 *  @return 文字size
 */
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
    
    return [self wb_sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping].width;
}
- (CGFloat)wb_heightForFont:(UIFont *)font
                      width:(CGFloat)width {
    
    return [self wb_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping].height;
}
#pragma mark --------  隐藏部分文字  --------
#pragma mark
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
#pragma mark
+ (NSString *)wb_digitUppercaseWithMoney:(NSString *)money {
    NSMutableString *moneyStr=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[money doubleValue]]];
    NSArray *MyScale=@[@"分", @"角", @"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *MyBase=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    NSArray *integerArray = @[@"拾", @"佰", @"仟", @"万", @"拾万", @"佰万", @"仟万", @"亿", @"拾亿", @"佰亿", @"仟亿", @"兆", @"拾兆", @"佰兆", @"仟兆"];
    
    
    NSMutableString * M = [[NSMutableString alloc] init];
    [moneyStr deleteCharactersInRange:NSMakeRange([moneyStr rangeOfString:@"."].location, 1)];
    for(NSInteger i=moneyStr.length;i>0;i--)
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
                    integerString = integerArray[moneyStr.length-4];
                }
                [M appendString:[NSString stringWithFormat:@"%@%@",integerString,@"元整"]];
                break;
            }
        }
        
        if([[moneyStr substringFromIndex:moneyStr.length-i+1] integerValue]==0
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

#pragma mark --------  Common Method  --------
#pragma mark
/**
 Returns NSMakeRange(0, self.length).
 */
- (NSRange)wb_rangeOfAll {
    return NSMakeRange(0, self.length);
}

#pragma mark --------  Private Method  --------
#pragma mark
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
#pragma mark
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

@end
