//
//  UIControl+WBAcitonBlock.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

/**  <
 GitHub：https://github.com/lavoy/ALActionBlocks
 Author：lavoy
 >  */

#import <UIKit/UIKit.h>

typedef void(^WBUIControlActionBlock)(id weakSender);

/**  < ControlEvents Block Wrapper >  */
@interface WBUIControlActionBlockWrapper : NSObject

@property (nonatomic, copy) WBUIControlActionBlock actionBlock;
@property (nonatomic, assign) UIControlEvents controlEvents;

- (void)wb_invokeBlock:(id)sender;

@end

@interface UIControl (WBAcitonBlock)

/**
 Handle control events with block.

 @param events events type
 @param block block description
 */
- (void)wb_handleControlEvents:(UIControlEvents)events
                     withBlock:(WBUIControlActionBlock)block;

/**
 Remove control events action block.

 @param events events type
 */
- (void)wb_removeActionBlocksForControlEvents:(UIControlEvents)events;

@end
