//
//  NSMutableAttributedString+WBAdditional.m
//  Pods-WBCategoryKit_Example
//
//  Created by Mr_Lucky on 2018/10/11.
//

#import "NSMutableAttributedString+WBAdditional.h"

@implementation NSMutableAttributedString (WBAdditional)

- (void)wb_makeAttributeWithFont:(UIFont *)font
                       textColor:(UIColor *)textColor
                     lineSpacing:(CGFloat)lineSpacing
                       alignment:(NSTextAlignment)alignment
                   lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSRange range = NSMakeRange(0, self.length);
    [self wb_makeAttributeWithFont:font
                         textColor:textColor
                       lineSpacing:lineSpacing
                         alignment:alignment
                     lineBreakMode:lineBreakMode
                             range:range];
    
}

- (void)wb_makeAttributeWithFont:(UIFont *)font
                       textColor:(UIColor *)textColor
                     lineSpacing:(CGFloat)lineSpacing
                       alignment:(NSTextAlignment)alignment
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                           range:(NSRange)range {
    [self addAttribute:NSFontAttributeName
                 value:font
                 range:range];
    
    //颜色
    [self addAttribute:NSForegroundColorAttributeName
                 value:textColor
                 range:range];
    
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    [self addAttribute:NSParagraphStyleAttributeName
                 value:paragraphStyle
                 range:range];
}

- (void)wb_makeAttributeWithFont:(UIFont *)font
                       textColor:(UIColor *)textColor
                     lineSpacing:(CGFloat)lineSpacing
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                           range:(NSRange)range {
    [self addAttribute:NSFontAttributeName
                 value:font
                 range:range];
    
    //颜色
    [self addAttribute:NSForegroundColorAttributeName
                 value:textColor
                 range:range];
    
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = lineBreakMode;
    [self addAttribute:NSParagraphStyleAttributeName
                 value:paragraphStyle
                 range:range];
}

- (void)wb_makeAttributeWithFont:(UIFont *)font
                       textColor:(UIColor *)textColor
                     lineSpacing:(CGFloat)lineSpacing
                       alignment:(NSTextAlignment)alignment
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                paragraphSpacing:(CGFloat)paragraphSpacing
             firstLineHeadIndent:(CGFloat)firstLineHeadIndent
                      headIndent:(CGFloat)headIndent

                           range:(NSRange)range {
    [self addAttribute:NSFontAttributeName
                 value:font
                 range:range];
    
    //颜色
    [self addAttribute:NSForegroundColorAttributeName
                 value:textColor
                 range:range];
    
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.paragraphSpacing = paragraphSpacing;
    paragraphStyle.firstLineHeadIndent = firstLineHeadIndent;
    paragraphStyle.headIndent = headIndent;
    [self addAttribute:NSParagraphStyleAttributeName
                 value:paragraphStyle
                 range:range];
}

- (void)wb_makeAttributeWithImage:(UIImage *)image
                           bounds:(CGRect)bounds
                          atIndex:(NSInteger)index {
    NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
    attachment.image = image;
    attachment.bounds = bounds;
    
    NSAttributedString *attributeStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [self insertAttributedString:attributeStr
                         atIndex:index];
}

- (void)wb_makeUnderLineWithStyle:(NSNumber *)style {
    [self wb_makeUnderLineWithStyle:style
                              range:NSMakeRange(0, self.length)];
}

- (void)wb_makeUnderLineWithStyle:(NSNumber *)style
                            range:(NSRange)range {
    [self addAttribute:NSUnderlineStyleAttributeName
                 value:style
                 range:range];
}

@end
