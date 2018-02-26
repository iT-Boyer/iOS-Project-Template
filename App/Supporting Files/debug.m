//
//  debug.m
//  Feel
//
//  Created by BB9z on 2/12/15.
//  Copyright (c) 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "debug.h"
#import "NSUserDefaults+App.h"
#import "MBAnalytics.h"

// @TODO
//MB_SHOULD_MERGE_INTO_LIB
void RFDebugger(NSString *format, ...) {
    if (format) {
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
    @try {
        @throw [NSException exceptionWithName:@"pause" reason:@"debug" userInfo:nil];
    }
    @catch (NSException *exception) { }
}

void DebugAlert(NSString *_Nonnull format, ...) {
    if (!AppDebugConfig().debugMode) return;

    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [UIAlertView showWithTitle:@"Debug Only" message:msg buttonTitle:nil];
}

void DebugLog(BOOL fatal, NSString *_Nullable recordID, NSString *_Nonnull format, ...) {
    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    if (fatal) {
        @try {
            @throw [NSException exceptionWithName:@"pause" reason:msg userInfo:nil];
        }
        @catch (NSException *exception) { }
    }
    MBCLog(@"%@", msg);
    if (AppDebugConfig().debugMode) {
        // alsert
        dispatch_sync_on_main(^{
            [UIAlertView showWithTitle:@"Debug Only" message:msg buttonTitle:nil];
        });
    }
    if (recordID
        && ![@MBBuildConfiguration isEqualToString:@"Debug"]) {
        [MBAnalytics recordError:[NSError errorWithDomain:recordID code:1 localizedDescription:msg] withAttributes:nil];
    }
}

void RFErrorAlert(NSString *_Nullable recordID, NSString *_Nonnull format, ...) {
    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    dispatch_sync_on_main(^{
        [UIAlertView showWithTitle:@"应用出错了" message:msg buttonTitle:@"(>﹏<)"];
    });

    if (recordID
        && ![@MBBuildConfiguration isEqualToString:@"Debug"]) {
        [MBAnalytics recordError:[NSError errorWithDomain:recordID code:1 localizedDescription:msg] withAttributes:nil];
    }
}

BOOL RFAssertKindOfClass(id obj, Class aClass) {
    if (obj
        && ![obj isKindOfClass:aClass]) {
        RFAssert(false, @"Expected kind of %@, actual is %@", aClass, [obj class]);
        return NO;
    }
    return YES;
}

BOOL RFAssertIsMainThread() {
    if (![NSThread isMainThread]) {
        RFAssert(false, @"thread mismatch");
        return NO;
    }
    return YES;
}

BOOL RFAssertNotMainThread() {
    if ([NSThread isMainThread]) {
        RFAssert(false, @"thread mismatch");
        return NO;
    }
    return YES;
}

#import <mach/mach.h>

unsigned long long MBApplicationMemoryUsed(void) {
    struct mach_task_basic_info info;
    mach_msg_type_number_t size = MACH_TASK_BASIC_INFO_COUNT;
    task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &size);
    return info.resident_size;
}

unsigned long long MBApplicationMemoryAll(void) {
    return [NSProcessInfo processInfo].physicalMemory;
}

BOOL DebugFlagForceLoadLocalAppConfig;

@implementation DebugConfig

- (void)synchronize {
    NSString *json = [self toJSONString];
    AppUserDefaultsShared().debugConfigJSON = json;
}

- (BOOL)productServer {
    return !self.debugServer && !self.alphaServer;
}

@end
