//
//  KATACheckUtils.m
//  SanDing
//
//  Created by 林 程宇 on 13-5-2.
//  Copyright (c) 2013年 Codeoem. All rights reserved.
//

#import "KATACheckUtils.h"
#import "Reachability/Reachability.h"

@implementation KATACheckUtils

+ (BOOL)isEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] isReachableViaWiFi]);
}

+ (BOOL)isEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] isReachableViaWWAN]);
}

+ (BOOL)isLink
{
    if ([KATACheckUtils isEnable3G] || [KATACheckUtils isEnableWIFI]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isRetina
{
    if ([[UIScreen mainScreen] scale] > 1.0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isOS4
{
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5) {
        return NO;
    }
    return YES;
}

@end
