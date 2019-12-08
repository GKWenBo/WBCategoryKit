//
//  UIView+WBFind.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIView (WBFind)

/// 当前视图控制器
@property (nonatomic, readonly, nullable) UIViewController *wb_viewController;

/**
 According to Class find subview.

 @param clazz class name.
 @return subview
 */
- (id)wb_findSubViewWithSubViewClass:(Class)clazz;

/**
 According to class find superview.

 @param clazz class name
 @return superview.
 */
- (id)wb_findSuperViewWithSuperViewClass:(Class)clazz;

/**
 Find first responder and resign first responder.

 @return YES/NO
 */
- (BOOL)wb_findAndResignFirstResponder;

/**
 Find first responder.

 @return view
 */
- (UIView *)wb_findFirstResponder;

@end
NS_ASSUME_NONNULL_END
