//
//  UIColor+WB_Additional.m
//  UIColorUtility
//
//  Created by WMB on 2017/6/2.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "UIColor+WBAdditional.h"

@implementation UIColor (WBAdditional)

- (CGFloat)wb_alpha {
    CGFloat a;
    if ([self getRed:0 green:0 blue:0 alpha:&a]) {
        return a;
    }
    return 0;
}

#pragma mark --------  随机色  --------
+ (UIColor *)wb_randomColor {
    UIColor *color;
    float randomRed   = (arc4random()%255)/255.0f;
    float randomGreen = (arc4random()%255)/255.0f;
    float randomBlue  = (arc4random()%255)/255.0f;
    
    color= [UIColor colorWithRed:randomRed
                           green:randomGreen
                            blue:randomBlue
                           alpha:1.0];
    return color;
}

#pragma mark --------  RGB/RGBA  --------
+ (UIColor *)wb_rgbaColorWithRed:(CGFloat)red
                           green:(CGFloat)green
                            blue:(CGFloat)blue
                           alpha:(CGFloat)alpha {
    return [self colorWithRed:red/255.0
                        green:green/255.0
                         blue:blue/255.0
                        alpha:alpha];
}

+ (UIColor *)wb_rgbColorWithRed:(CGFloat)red
                           green:(CGFloat)green
                            blue:(CGFloat)blue {
    return [self wb_rgbaColorWithRed:red
                               green:green
                                blue:blue
                               alpha:1.f];
}

- (NSArray <NSNumber *>*)wb_getRGBDictionary {
    CGFloat r = 0,g = 0,b = 0,a = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self getRed:&r
               green:&g
                blue:&b
               alpha:&a];
    } else {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    return @[@(r),
             @(g),
             @(b),
             @(a)];
}

+ (NSArray <NSNumber *>*)wb_transColorWithBeginColor:(UIColor *)beginColor
                                            endColor:(UIColor *)endColor {
    NSArray <NSNumber *>*beginColors = [beginColor wb_getRGBDictionary];
    NSArray <NSNumber *>*endColors = [endColor wb_getRGBDictionary];
    return @[@(endColors[0].doubleValue - beginColors[0].doubleValue),
             @(endColors[1].doubleValue - beginColors[1].doubleValue),
             @(endColors[2].doubleValue - beginColors[2].doubleValue)];
}

- (CGFloat *)wb_getRGB {
    UIColor *uiColor = self;
    CGColorRef cgColor = [uiColor CGColor];
    int numComponents = (int)CGColorGetNumberOfComponents(cgColor);
    if (numComponents == 4){
        static CGFloat *components = Nil;
        components = (CGFloat *)CGColorGetComponents(cgColor);
        return (CGFloat *)components;
    } else { //否则默认返回黑色
        static CGFloat components[4] = {0};
        CGFloat f = 0;
        //非RGB空间的系统颜色单独处理
        if ([uiColor isEqual:[UIColor whiteColor]]) {
            f = 1.0;
        } else if ([uiColor isEqual:[UIColor lightGrayColor]]) {
            f = 0.8;
        } else if ([uiColor isEqual:[UIColor grayColor]]) {
            f = 0.5;
        }
        components[0] = f;
        components[1] = f;
        components[2] = f;
        components[3] = 1.0;
        return (CGFloat *)components;
    }
}

- (CGFloat)wb_saturation {
    CGFloat s;
    if ([self getHue:0 saturation:&s brightness:0 alpha:0]) {
        return s;
    }
    return 0;
}

- (CGFloat)wb_brightness {
    CGFloat b;
    if ([self getHue:0 saturation:0 brightness:&b alpha:0]) {
        return b;
    }
    return 0;
}

- (UIColor *)wb_colorWithoutAlpha {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    if ([self getRed:&r green:&g blue:&b alpha:0]) {
        return [UIColor colorWithRed:r green:g blue:b alpha:1];
    } else {
        return nil;
    }
}

- (UIColor *)wb_colorWithAlpha:(CGFloat)alpha
               backgroundColor:(nullable UIColor *)backgroundColor {
    return [UIColor wb_colorWithBackendColor:backgroundColor
                                  frontColor:[self colorWithAlphaComponent:alpha]];
}

- (UIColor *)wb_colorWithAlphaAddedToWhite:(CGFloat)alpha {
    return [self wb_colorWithAlpha:alpha
                   backgroundColor:[UIColor whiteColor]];
}

+ (UIColor *)wb_colorWithBackendColor:(UIColor *)backendColor
                           frontColor:(UIColor *)frontColor {
    NSArray <NSNumber *>*bgColors = [backendColor wb_getRGBDictionary];
    NSArray <NSNumber *>*frColors = [frontColor wb_getRGBDictionary];
    
    CGFloat bgAlpha = bgColors[3].floatValue;
    CGFloat bgRed = bgColors[0].floatValue;
    CGFloat bgGreen = bgColors[1].floatValue;
    CGFloat bgBlue = bgColors[2].floatValue;
    
    CGFloat frAlpha = frColors[3].floatValue;
    CGFloat frRed = frColors[0].floatValue;
    CGFloat frGreen = frColors[1].floatValue;
    CGFloat frBlue = frColors[2].floatValue;
    
    CGFloat resultAlpha = frAlpha + bgAlpha * (1 - frAlpha);
    CGFloat resultRed = (frRed * frAlpha + bgRed * bgAlpha * (1 - frAlpha)) / resultAlpha;
    CGFloat resultGreen = (frGreen * frAlpha + bgGreen * bgAlpha * (1 - frAlpha)) / resultAlpha;
    CGFloat resultBlue = (frBlue * frAlpha + bgBlue * bgAlpha * (1 - frAlpha)) / resultAlpha;
    return [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:resultAlpha];
}

#pragma mark --------  Hex Color  --------
+ (UIColor *)wb_colorWithHexString:(NSString *)color
                             alpha:(CGFloat)alpha {
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)wb_colorWithHexString:(NSString *)color {
    return [self wb_colorWithHexString:color
                                 alpha:1.f];
}

+ (UIColor *)wb_colorWithRGB:(uint32_t)rgbValue {
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

+ (UIColor *)wb_colorWithRGBA:(uint32_t)rgbaValue {
    return [UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24) / 255.0f
                           green:((rgbaValue & 0xFF0000) >> 16) / 255.0f
                            blue:((rgbaValue & 0xFF00) >> 8) / 255.0f
                           alpha:(rgbaValue & 0xFF) / 255.0f];
}

+ (UIColor *)wb_colorWithRGB:(uint32_t)rgbValue
                       alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:alpha];
}

- (NSString *)wb_getHexString {
    UIColor* color = self;
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

#pragma mark 渐变色
+ (UIColor *)wb_gradientFromColor:(UIColor *)c1
                          toColor:(UIColor *)c2
                       startPoint:(CGPoint)startPoint
                         endPoint:(CGPoint)endPoint {
    CGSize size = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray *colors = [NSArray arrayWithObjects:(id)c1.CGColor,
                                                (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    ///设置渐变方向
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    ///生成图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)wb_getGradientColorWithBeginColor:(UIColor *)beginColor
                                      endColor:(UIColor *)endColor
                                         ratio:(double)ratio {
    ratio = MIN(ratio, 1.0f);
    NSArray <NSNumber *>*beginColors = [beginColor wb_getRGBDictionary];
    NSArray <NSNumber *>*diffColors = [self wb_transColorWithBeginColor:beginColor
                                                               endColor:endColor];
    double r = beginColors[0].doubleValue + ratio * diffColors[0].doubleValue;
    double g = beginColors[1].doubleValue + ratio * diffColors[1].doubleValue;
    double b = beginColors[2].doubleValue + ratio * diffColors[2].doubleValue;
    return [UIColor colorWithRed:r
                           green:g
                            blue:b
                           alpha:1.f];
}

// MARK: -------- Utility
- (BOOL)wb_colorIsDark {
    CGFloat red = 0.0, green = 0.0, blue = 0.0;
    if ([self getRed:&red green:&green blue:&blue alpha:0]) {
        float referenceValue = 0.411;
        float colorDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
        
        return 1.0 - colorDelta > referenceValue;
    }
    return YES;
}

- (BOOL)wb_isSystemTintColor {
    return [self isEqual:[UIColor wb_systemTintColor]];
}

+ (UIColor *)wb_systemTintColor {
    static UIColor *systemTintColor = nil;
    if (!systemTintColor) {
        UIView *view = [[UIView alloc] init];
        systemTintColor = view.tintColor;
    }
    return systemTintColor;
}

@end
