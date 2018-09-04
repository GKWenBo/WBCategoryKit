//
//  UIApplication+WBNetworkActivityIndicator.m
//  WBCategories
//
//  Created by WMB on 2018/2/8.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIApplication+WBNetworkActivityIndicator.h"

#import <libkern/OSAtomic.h>

static volatile int32_t numberOfActiveNetworkConnectionsxxx;

@implementation UIApplication (WBNetworkActivityIndicator)

- (void)wb_beganNetworkActivity {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.networkActivityIndicatorVisible = OSAtomicAdd32(1, &numberOfActiveNetworkConnectionsxxx) > 0;
 #pragma clang diagnostic pop
}

- (void)wb_endedNetworkActivity
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.networkActivityIndicatorVisible = OSAtomicAdd32(-1, &numberOfActiveNetworkConnectionsxxx) > 0;
 #pragma clang diagnostic pop
}

@end
