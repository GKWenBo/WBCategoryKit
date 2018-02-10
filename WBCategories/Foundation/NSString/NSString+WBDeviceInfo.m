//
//  NSString+WBDeviceInfo.m
//  Demo
//
//  Created by WMB on 2017/9/24.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "NSString+WBDeviceInfo.h"

@implementation NSString (WBDeviceInfo)
+ (void)wb_check {
    CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier*carrier = info.subscriberCellularProvider;
    NSString*carrierName = carrier.carrierName;
    NSString*mobileCountryCode = carrier.mobileCountryCode;
    NSString*mobileNetworkCode = carrier.mobileNetworkCode;
    NSLog(@"carrier=%@ /n carrierName=%@ /n mobileCountryCode=%@ /n networkCode = %@",carrier,carrierName,mobileCountryCode,mobileNetworkCode);
}

+ (NSString *)wb_getCurrentOperatorName {
    CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier*carrier = info.subscriberCellularProvider;
    return carrier.carrierName;
}

+ (NSString *)wb_getAppCurrentVersion {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (NSString *)wb_stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

+ (NSString *)wb_getApplicationVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleVersion"];
    return version;
}

+ (NSString *)wb_getIdentifier {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)wb_getApplicationDisplayName {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [info objectForKey:@"CFBundleDisplayName"];
    return name;
}

- (NSString *)wb_getBoundleName {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    return appName;
}

@end
