//
//  UINavigationItem+WBLoading.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

/**  <
 GitHub：https://github.com/Just-/UINavigationItem-Loading
 Author：Just
 >  */

#import <UIKit/UIKit.h>

/**
 *  Position to show UIActivityIndicatorView in a navigation bar
 */
typedef NS_ENUM(NSUInteger, WBNavBarLoaderPosition){
    /**
     *  Will show UIActivityIndicatorView in place of title view
     */
    WBNavBarLoaderPositionCenter = 0,
    /**
     *  Will show UIActivityIndicatorView in place of left item
     */
    WBNavBarLoaderPositionLeft,
    /**
     *  Will show UIActivityIndicatorView in place of right item
     */
    WBNavBarLoaderPositionRight
};


@interface UINavigationItem (WBLoading)

/**
 *  Add UIActivityIndicatorView to view hierarchy and start animating immediately
 *
 *  @param position Left, center or right
 */
- (void)wb_startAnimatingAt:(WBNavBarLoaderPosition)position;

/**
 *  Stop animating, remove UIActivityIndicatorView from view hierarchy and restore item
 */
- (void)wb_stopAnimating;

@end
