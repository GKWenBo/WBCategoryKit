//
//  UIScrollView+WBScrollDirection.h
//  Pods-WBCategoryKit_Example
//
//  Created by Mr_Lucky on 2018/11/6.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBScrollDirection) {
    WBScrollDirectionUp,    /*  < 向上滚动 > */
    WBScrollDirectionDown,
    WBScrollDirectionLeft,
    WBScrollDirectionRight,
    WBScrollDirectionWTF
};

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (WBScrollDirection)

@property (nonatomic, assign, readonly) WBScrollDirection scrollDiretion;

@end

NS_ASSUME_NONNULL_END
