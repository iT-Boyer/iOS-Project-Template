//
//  UIDevice+ZYIdentifier.m
//  Feel
//
//  Created by BB9z on 6/20/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "UIDevice+ZYIdentifier.h"
#import "API.h"
#import "AFNetworkReachabilityManager.h"
#import <sys/utsname.h>
@import CoreTelephony;

@implementation UIDevice (ZYIdentifier)

+ (NSString *)ZYAccessTechnology {
    CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
    return telephonyInfo.currentRadioAccessTechnology;
}

+ (NSString *)ZYReadableNetworkAccessTechnology {
    AFNetworkReachabilityStatus s = API.global.reachabilityManager.networkReachabilityStatus;
    if (s == AFNetworkReachabilityStatusReachableViaWiFi) {
        return @"wifi";
    }
    else if (s == AFNetworkReachabilityStatusUnknown) {
        return @"unknow";
    }
    else if (s == AFNetworkReachabilityStatusNotReachable) {
        return @"NA";
    }
    NSString *t = self.ZYAccessTechnology;
    if (!t) return @"unknow";
    if ([t isEqualToString:CTRadioAccessTechnologyGPRS]
        || [t isEqualToString:CTRadioAccessTechnologyEdge]
        || [t isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        return @"2G";
    }
    else if ([t isEqualToString:CTRadioAccessTechnologyWCDMA]
             || [t isEqualToString:CTRadioAccessTechnologyeHRPD]
             || [t isEqualToString:CTRadioAccessTechnologyHSDPA]
             || [t isEqualToString:CTRadioAccessTechnologyHSUPA]
             || [t isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]
             || [t isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]
             || [t isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]
             || [t isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        return @"3G";
    }
    else if ([t isEqualToString:CTRadioAccessTechnologyLTE]) {
        return @"4G";
    }
    else {
        return t;
    }
}

@end
