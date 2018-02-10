//
//  UINavigationItem+WBLoading.m
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UINavigationItem+WBLoading.h"
#import <objc/runtime.h>

static void *WBLoaderPositionAssociationKey = &WBLoaderPositionAssociationKey;
static void *WBSubstitutedViewAssociationKey = &WBSubstitutedViewAssociationKey;

@implementation UINavigationItem (WBLoading)

- (void)wb_startAnimatingAt:(WBNavBarLoaderPosition)position {
    // stop previous if animated
    [self wb_stopAnimating];
    
    // hold reference for position to stop at the right place
    objc_setAssociatedObject(self, WBLoaderPositionAssociationKey, @(position), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIActivityIndicatorView* loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // substitute bar views to loader and hold reference to them for restoration
    switch (position) {
        case WBNavBarLoaderPositionLeft:
            objc_setAssociatedObject(self, WBSubstitutedViewAssociationKey, self.leftBarButtonItem.customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.leftBarButtonItem.customView = loader;
            break;
            
        case WBNavBarLoaderPositionCenter:
            objc_setAssociatedObject(self, WBSubstitutedViewAssociationKey, self.titleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.titleView = loader;
            break;
            
        case WBNavBarLoaderPositionRight:
            objc_setAssociatedObject(self, WBSubstitutedViewAssociationKey, self.rightBarButtonItem.customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.rightBarButtonItem.customView = loader;
            break;
    }
    
    [loader startAnimating];
}

- (void)wb_stopAnimating {
    NSNumber* positionToRestore = objc_getAssociatedObject(self, WBLoaderPositionAssociationKey);
    id componentToRestore = objc_getAssociatedObject(self, WBSubstitutedViewAssociationKey);
    
    // restore UI if animation was in a progress
    if (positionToRestore) {
        switch (positionToRestore.intValue) {
            case WBNavBarLoaderPositionLeft:
                self.leftBarButtonItem.customView = componentToRestore;
                break;
                
            case WBNavBarLoaderPositionCenter:
                self.titleView = componentToRestore;
                break;
                
            case WBNavBarLoaderPositionRight:
                self.rightBarButtonItem.customView = componentToRestore;
                break;
        }
    }
    
    objc_setAssociatedObject(self, WBLoaderPositionAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, WBSubstitutedViewAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
