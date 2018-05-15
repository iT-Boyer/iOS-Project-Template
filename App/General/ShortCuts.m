
#import "ShortCuts.h"
#import "App-Swift.h"
#import "DataStack.h"
#import "MBApp.h"
#import "MBNavigationController.h"

/**
 备忘
 
 保持这里的纯粹性——只提供快捷访问，和必要的简单变量缓存。
 不在这写创建逻辑，会导致难于维护
 */
DebugConfig *AppDebugConfig() {
    return [MBApp status].debugConfig;
}

MBEnvironment *AppEnv() {
    return [MBApp status].env;
}

#import "APApplicationDelegate.h"

APApplicationDelegate *__nonnull AppDelegate() {
    APApplicationDelegate *ad = (id)[UIApplication sharedApplication].delegate;
    RFAssert(ad, @"Shared app delegate nil?");
    return ad;
}

#import "MBRootWrapperViewController.h"

RootViewController *_Nullable AppRootViewController() {
    return RootViewController.globalController;
}

MBNavigationController *__nullable AppNavigationController() {
    return [MBApp status].globalNavigationController;
}

//MBWorkerQueue *AppWorkerQueue() {
//    return [MBApp status].workerQueue;
//}
//
//MBWorkerQueue *AppBackgroundWorkerQueue() {
//    return [MBApp status].backgroundWorkerQueue;
//}

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
    MBNavigationController *nav = AppNavigationController();
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

API *AppAPI(void) {
    return MBApp.status.api;
}

APINetworkActivityManager *__nonnull AppHUD(void) {
    return MBApp.status.hud;
}

#pragma mark -

APUser *__nullable AppUser() {
    return [APUser currentUser];
}

MBID AppUserID() {
    return AppUser().uid;
}

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

APUserInfo *AppUserInformation() {
    return AppUser().information;
}

#pragma mark -

NSUserDefaults *AppUserDefaultsShared() {
    return [NSUserDefaults standardUserDefaults];
}

NSAccountDefaults *_Nullable AppUserDefaultsPrivate() {
    return AppUser().profile;
}

#import <Realm/Realm.h>

static RLMRealm *_StorageMain;

RLMRealm *AppStorageShared() {
    if (!_StorageMain) {
        _StorageMain = [MBApp status].dataStack.sharedStorage;
    }
    return _StorageMain;
}

RLMRealm *_Nullable AppStoragePrivate() {
    return AppUser().storage;
}

BOOL AppActive() {
    return [UIApplication sharedApplication].applicationState == UIApplicationStateActive;
}

BOOL AppInBackground() {
    return [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
}
