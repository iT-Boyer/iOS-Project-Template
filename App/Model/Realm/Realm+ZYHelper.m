//
//  RLMRealm+ZYHelper.m
//  Feel
//
//  Created by BB9z on 7/28/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Realm+ZYHelper.h"
#import "MBApp.h"

@implementation RLMObject (ZYHelper)

+ (RLMResults *)resultsWithPredicateFormat:(NSString *)predicateFormat, ... {
    va_list args;
    va_start(args, predicateFormat);
    NSPredicate *pd = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
    va_end(args);
    RLMRealm *s = AppStoragePrivate();
    if (![NSThread isMainThread]) {
        s = [RLMRealm realmWithConfiguration:s.configuration error:nil];
        s.autorefresh = NO;
    }
    RLMResults *result = nil;
    if (s) {
        result = [self objectsInRealm:s withPredicate:pd];
    }
    return result;
}

@end
