//
//  UIBarItem+WBAdditional.m
//  Pods
//
//  Created by WenBo on 2019/11/21.
//

#import "UIBarItem+WBAdditional.h"
#import "WBCategoryKitCore.h"

@implementation UIBarItem (WBAdditional)

- (UIView *)wb_view {
    if ([self respondsToSelector:@selector(view)]) {
        return [self wb_valueForKey:@"view"];
    }
    return nil;
}

@end
