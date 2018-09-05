//
//  UIControl+WBBlock.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

/**  <
 GitHub：https://github.com/foxsofter/FXCategories
 Author：foxsofter
 >  */

#import <UIKit/UIKit.h>

@interface UIControl (WBBlock)

- (void)wb_touchDown:(void (^)(void))eventBlock;
- (void)wb_touchDownRepeat:(void (^)(void))eventBlock;
- (void)wb_touchDragInside:(void (^)(void))eventBlock;
- (void)wb_touchDragOutside:(void (^)(void))eventBlock;
- (void)wb_touchDragEnter:(void (^)(void))eventBlock;
- (void)wb_touchDragExit:(void (^)(void))eventBlock;
- (void)wb_touchUpInside:(void (^)(void))eventBlock;
- (void)wb_touchUpOutside:(void (^)(void))eventBlock;
- (void)wb_touchCancel:(void (^)(void))eventBlock;
- (void)wb_valueChanged:(void (^)(void))eventBlock;
- (void)wb_editingDidBegin:(void (^)(void))eventBlock;
- (void)wb_editingChanged:(void (^)(void))eventBlock;
- (void)wb_editingDidEnd:(void (^)(void))eventBlock;
- (void)wb_editingDidEndOnExit:(void (^)(void))eventBlock;

@end
