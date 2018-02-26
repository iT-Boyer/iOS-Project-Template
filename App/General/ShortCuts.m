//
//  ShortCuts.m
//  Feel
//
//  Created by BB9z on 12/12/15.
//  Copyright © 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "ShortCuts.h"
#import "DataStack.h"
#import "MBApp.h"

/**
 备忘
 
 保持这里的纯粹性——只提供快捷访问，和必要的简单变量缓存。
 不在这写创建逻辑，会导致难于维护
 */

#ifndef DEMO
DebugConfig *AppDebugConfig() {
    return [MBApp status].debugConfig;
}
#else
id AppDebugConfig() {
    return nil;
}
#endif

MBEnvironment *AppEnv() {
    return [MBApp status].env;
}

#ifndef DEMO
#import "MBRootWrapperViewController.h"

MBRootWrapperViewController *_Nullable AppRootViewController() {
    return [MBRootWrapperViewController globalController];
}

ZYNavigationController *__nullable AppNavigationController() {
    return [MBApp status].globalNavigationController;
}
#else
id AppRootViewController() { return nil; }
id AppNavigationController() { return nil; }
#endif

#ifndef DEMO
MBWorkerQueue *AppWorkerQueue() {
    return [MBApp status].workerQueue;
}

MBWorkerQueue *AppBackgroundWorkerQueue() {
    return [MBApp status].backgroundWorkerQueue;
}
#else
id AppWorkerQueue() { return nil; }
id AppBackgroundWorkerQueue() { return nil; }
#endif

static BOOL _itemFitClass(id __nullable item, Class __nullable exceptClass) {
    if (!item) return NO;
    if (exceptClass) {
        return [item isKindOfClass:exceptClass];
    }
    else {
        return YES;
    }
}

id __nullable AppCurrentViewControllerItem(Class __nullable exceptClass) {
    ZYNavigationController *nav = AppNavigationController();
    UIViewController<MBGeneralItemExchanging> *vc = (id)(nav.presentedViewController?: nav.topViewController);
    id item = nil;
    if ([vc respondsToSelector:@selector(item)]) {
        item = vc.item;
    }
    if (_itemFitClass(item, exceptClass)) {
        return item;
    }
    for (UIViewController<MBGeneralItemExchanging> *subVC in vc.childViewControllers) {
        if ([subVC respondsToSelector:@selector(item)]) {
            item = subVC.item;
        }
        if (_itemFitClass(item, exceptClass)) {
            return item;
        }
    }
    return nil;
}

#pragma mark -

#ifndef DEMO
MBUser *__nullable AppUser() {
    return [MBUser currentUser];
}
#else
id AppUser() { return nil; }
#endif

#ifndef DEMO
MBID AppUserID() {
    return AppUser().uid;
}
#else
MBID AppUserID() {
    return 0;
}
#endif

static NSNumber *_UserIDNumberCache;
static MBID _UserIDNumberCacheVerify;
NSNumber *AppUserIDNumber() {
    if (_UserIDNumberCache
        && AppUserID() == _UserIDNumberCacheVerify) {
        return _UserIDNumberCache;
    }
    _UserIDNumberCache = @(AppUserID());
    return _UserIDNumberCache;
}

#ifndef DEMO
UserInformation *AppUserInformation() {
    return AppUser().information;
}
#else
id AppUserInformation() { return nil; }
#endif

#ifndef DEMO
APIUserPlugin *AppUserManager() {
    return [API sharedInstance].user;
}
#else
id AppUserManager() { return nil; }
#endif

#pragma mark -

NSUserDefaults *AppUserDefaultsShared() {
    return [NSUserDefaults standardUserDefaults];
}

#ifndef DEMO
MBUserProfiles *_Nullable AppUserDefaultsPrivate() {
    return AppUser().profile;
}
#else
id AppUserDefaultsPrivate() { return nil; }
#endif

#import <Realm/Realm.h>

static RLMRealm *_StorageMain;

RLMRealm *AppStorageShared() {
    if (!_StorageMain) {
        _StorageMain = [MBApp status].dataStack.sharedStorage;
    }
    return _StorageMain;
}

#ifndef DEMO
RLMRealm *_Nullable AppStoragePrivate() {
    return AppUser().storage;
}
#else
id AppStoragePrivate() { return nil; }
#endif

BOOL AppActive() {
    return [UIApplication sharedApplication].applicationState == UIApplicationStateActive;
}

BOOL AppInBackground() {
    return [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
}

NSString *__nonnull AppShareDomain(NSString *__nullable path) {
    NSString *domain = [MBApp status].appConfig.shareDomain?: @"https://share.feelapp.cc";
    if (path) {
        RFAssert([path characterAtIndex:0] == '/', @"路径应以/开头");
        return [domain stringByAppendingString:path];
    }
    return domain;
}

