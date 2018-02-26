//
//  ZYNavigationController+AppJump.m
//  Very+
//
//  Created by BB9z on 8/19/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd. All rights reserved.
//

#import "MBApp.h"
#import "MBNavigationController.h"
#import "NSURL+RFKit.h"

UIViewController * _ViewControllerNM(NSString *NibID, NSString *code);
extern NSURL *_ZYNavigationControllerURLWaitToJump;

@implementation MBNavigationController (AppJump)

- (NSURL *)currentPageURL {
    UIViewController *vc = self.presentedViewController?: self.topViewController;
    return [vc respondsToSelector:@selector(pageURL)]? vc.pageURL : nil;
}

#define _CommandJump(STRING, VCCLASS, MODEL) \
    else if ([command isEqualToString:STRING]) {\
        vc = (id)[VCCLASS newFromStoryboard];\
        MODEL *item = [MODEL new];\
        item.uid = itemID;\
        if ([item respondsToSelector:@selector(setIncompletion:)]) {\
            [(id<MBModelCompleteness>)item setIncompletion:@(YES)];\
        }\
        if ([item respondsToSelector:@selector(completeEntityFromCache)]) {\
            item = [(id<MBModelCompleteness>)item completeEntityFromCache];\
        }\
        vc.item = item;\
    }

#define _CommandJumpVC(STRING, VCCLASS) \
    else if ([command isEqualToString:STRING]) {\
        vc = (id)[VCCLASS newFromStoryboard];\
    }

- (void)navigationWithURL:(NSURL *)feelURL {
    if (isNull(feelURL)) {
        DebugLog(NO, nil, @"空的跳转连接");
        return;
    }
    else if ([feelURL isKindOfClass:[NSString class]]) {
        NSString *orgURL = (NSString *)feelURL;
        feelURL = [NSURL URLWithString:orgURL];
        if (!feelURL) {
            DebugLog(YES, @"BadJumpURL", @"没有转义或非法的跳转链接 %@", orgURL);
            return;
        }
    }
    else if (![feelURL isKindOfClass:[NSURL class]]) {
        RFAssert(false, @"mismatch type");
        return;
    }

    _dout_debug(@"跳转链接到 %@", feelURL)
    NSString *sc = feelURL.scheme;

    // 网页
    if ([sc isEqualToString:@"http"]
        || [sc isEqualToString:@"https"]) {
        // 网页白名单跳 Safari
        [[UIApplication sharedApplication] openURL:feelURL];
        return;
    }

    if (![feelURL.scheme containsString:@"feel"]) {
        dout_warning(@"不允许打开的链接：%@", feelURL);
        return;
    }

    // 相同页面不再跳转
    NSURL *currentPageURL = [self.topViewController respondsToSelector:@selector(pageURL)]? self.topViewController.pageURL : nil;
    if ([feelURL isEqual:currentPageURL]) {
        return;
    }

    NSString *command = feelURL.host;
    // 无命令则不是一个有效命令，忽略
    if (!command) return;

    _douto(feelURL.query)
    NSDictionary *queryDictionary = feelURL.queryDictionary;
    BOOL silent = !!queryDictionary[@"silent"];
    NSArray *pathComponents = feelURL.pathComponents;
    NSString *itemIDString = [pathComponents rf_objectAtIndex:1];
    MBID itemID = [itemIDString longLongValue];

    UIViewController<MBGeneralItemExchanging> *vc;

    if (0) {
        // for else below
    }

#pragma mark Load Class
    // 根据类载入视图
    else if ([command isEqualToString:@"_mn"]) {
        NSString *class = queryDictionary[@"id"];
        NSString *code = queryDictionary[@"_s"];
        vc = (id)_ViewControllerNM(class, code);
        if (!vc) {
            DebugLog(YES, @"TE_BadMN", @"错误的内部链接 %@", feelURL);
        }
    }

#pragma mark - Push VC
    if (vc) {
        NSString *pageName = queryDictionary[@"page_name"];
        if (pageName) {
            vc.title = pageName;
        }
        NSString *title = queryDictionary[@"title"];
        if (title) {
            vc.navigationItem.title = title;
        }
        [self pushViewController:vc animated:YES];
    }
    else {
        if (!silent) {
            // @TODO
//            [[MBNotificationCenter sharedInstance] premoteAppUpdateWithMessage:nil];
            return;
        }
    }
}

@end

void APNavigationControllerJumpWithURL(id url) {
    MBNavigationController *nav = AppNavigationController();
    if (nav.isNavigationReadyForURLJump) {
        [nav navigationWithURL:url];
        _ZYNavigationControllerURLWaitToJump = nil;
    }
    else {
        _ZYNavigationControllerURLWaitToJump = url;
    }
}

UIViewController * _ViewControllerNM(NSString *NibID, NSString *code) {
    if (code.length < 8) return nil;

    NSString *trueCode = [NSString stringWithFormat:@"%@v1", NibID].rf_MD5String;
    if (![trueCode containsString:code]) return nil;

    @try {
        Class vcClass = NSClassFromString(NibID);
        if (vcClass) {
            return [vcClass newFromStoryboard];
        }
    }
    @catch (NSException *exception) {
        // Silent
    }
    return nil;
}
