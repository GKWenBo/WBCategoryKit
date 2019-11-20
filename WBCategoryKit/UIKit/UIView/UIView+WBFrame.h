//
//  UIView+WB_Frame.h
//  WB_CommonUtility
//
//  Created by WMB on 2017/5/14.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WBFrame)

@property (nonatomic, assign) CGFloat wb_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic, assign) CGFloat wb_top;         ///< Shortcut for frame.origin.y
@property (nonatomic, assign) CGFloat wb_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat wb_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat wb_width;       ///< Shortcut for frame.size.width.
@property (nonatomic, assign) CGFloat wb_height;      ///< Shortcut for frame.size.height.
@property (nonatomic, assign) CGFloat wb_centerX;     ///< Shortcut for center.x
@property (nonatomic, assign) CGFloat wb_centerY;     ///< Shortcut for center.y
@property (nonatomic, assign) CGPoint wb_origin;      ///< Shortcut for frame.origin.
@property (nonatomic, assign) CGSize  wb_size;        ///< Shortcut for frame.size.
/**  < 最大x值 >  */
@property (nonatomic, assign) CGFloat wb_maxX;
/**  < 最大值 >  */
@property (nonatomic, assign) CGFloat wb_maxY;

@end
