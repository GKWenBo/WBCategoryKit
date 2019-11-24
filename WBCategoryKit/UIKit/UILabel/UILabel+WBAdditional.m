//
//  UILabel+WBAdditional.m
//  Pods-WBCategoryKit_Example
//
//  Created by WenBo on 2019/11/13.
//

#import "UILabel+WBAdditional.h"
#import <objc/runtime.h>

#import "WBCategoryKitCore.h"

@implementation UILabel (WBAdditional)

- (NSString *)wb_verticalText {
    return objc_getAssociatedObject(self, @selector(wb_verticalText));
}

- (void)setWb_verticalText:(NSString *)wb_verticalText {
    objc_setAssociatedObject(self, @selector(wb_verticalText), wb_verticalText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableString *str = [[NSMutableString alloc]initWithString:wb_verticalText];
    for (int i = 0; i < str.length; i ++) {
        [str insertString:@"\n" atIndex:i * 2 - 1];
    }
    self.text = str;
    self.numberOfLines = 0;
}

- (instancetype)wb_initWithFont:(nullable UIFont *)font
                      textColor:(nullable UIColor *)textColor {
    WBBeginIgnoreClangWarning(-Wunused-value)
    [self init];
    WBEndIgnoreClangWarning
    self.font = font;
    self.textColor = textColor;
    return self;
}

- (void)wb_changeAligmentLeftAndRight {
    CGFloat w = self.bounds.size.width;
    if (w <= 0) {
        [self layoutIfNeeded];
    }
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(w, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName : self.font}
                                              context:nil].size;
    CGFloat margin = (self.frame.size.width - textSize.width) / (self.text.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributeStr addAttribute:NSKernAttributeName
                         value:number
                         range:NSMakeRange(0, self.text.length - 1)];
    self.attributedText = attributeStr;
}

@end
