
#import "MBApplicationDelegate.h"
#import "MBAnalytics.h"
#import "MBApp.h"
//#import "MBRootWrapperViewController.h"
#import "NSFileManager+RFKit.h"
#import "RFDrawImage.h"
#import "SVProgressHUD.h"
#import "debug.h"

#import "NSJSONSerialization+RFKit.h"

MBApplicationDelegate *__nonnull AppDelegate() {
    MBApplicationDelegate *ad = (id)[UIApplication sharedApplication].delegate;
    RFAssert(ad, @"Shared app delegate nil?");
    return ad;
}

@interface MBApplicationDelegate ()
@property (nonatomic, strong) NSHashTable *eventListeners;

@property (nonatomic) BOOL backgroundMode;
@property (strong, nonatomic) UIApplication *suspendApplication;
@property (strong, nonatomic) NSDictionary *suspendLaunchOptions;
@end

@implementation MBApplicationDelegate

#pragma mark - Launch

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _applicationLaunchTime = CFAbsoluteTimeGetCurrent();
    _applicationLastLaunchTime = AppUserDefaultsShared().applicationLastLaunchTime;
    AppUserDefaultsShared().applicationLastLaunchTime = [NSDate date];

#if RFDEBUG
//    [MBAnalytics startFabric];
// @TODO
//    [ZYDBContextWatchDog start];
#else
//    if (AppDebugConfig().debugMode) {
//        [ZYDBContextWatchDog start];
//    }
#endif

    [MBApp status];
    return YES;
}

#ifndef DEMO
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    if (application.applicationState == UIApplicationStateBackground) {
        self.backgroundMode = YES;
    }
    else {
        // 第一次，或上次未成功启动
        NSUserDefaults *ud = AppUserDefaultsShared();
        if (!ud.launchGuard) {
            // 上次启动可能出问题了，开统计
//            [MBAnalytics startFabric];

            NSURL *jpushCacheFile = [[NSFileManager defaultManager] subDirectoryURLWithPathComponent:@"Jpush" inDirectory:NSCachesDirectory createIfNotExist:NO error:nil];
            [[NSFileManager defaultManager] removeItemAtURL:jpushCacheFile error:nil];
        }
        ud.launchGuard = NO;

        // 3s 后认为应用这次启动成功了
        dispatch_after_seconds(3, ^{
            AppUserDefaultsShared().launchGuard = YES;
        });
    }

    [MBAnalytics logEventWithName:@"TI_Launch" attributes:@{
        @"启动状态" : self.backgroundMode? @"Background" : @"Active"
    }];

    if (AppDebugConfig().debugMode) {
        if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
            DebugLog(NO, nil, @"后台地址启动");
        }
    }

    [application setMinimumBackgroundFetchInterval:3600 * 2];
    [MBAnalytics setup];
    [MBUser setup];
    
    if (self.backgroundMode) {
        self.window.rootViewController = nil;
        self.suspendApplication = application;
        self.suspendLaunchOptions = launchOptions;
    }
    else {
        [self doLaunchApplication:application launchOptions:launchOptions];
    }
    return YES;
}

- (void)tryResumeLaunch {
    if (!self.backgroundMode) return;
    self.backgroundMode = NO;

    // @TODO
//    self.window.rootViewController = [MBRootWrapperViewController globalController];
    [self doLaunchApplication:self.suspendApplication launchOptions:self.suspendLaunchOptions];
    self.suspendApplication = nil;
    self.suspendLaunchOptions = nil;
}

- (void)doLaunchApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    // 全局点击空白隐藏键盘
    [RFKeyboard setEnableAutoDisimssKeyboardWhenTouch:YES];

    [self generalAppearanceSetup];
    [AppEnv() setFlagOn:MBENVAppHasEnterForegroundOnce];
    [AppEnv() setFlagOn:MBENVAppInForeground];
}

- (void)generalAppearanceSetup {
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor globalTintColor];

    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"hud_error"]];
//    [[SVProgressHUD appearance] setHudRingForegroundColor:[UIColor globalTintColor]];

    NSDictionary *navTitleAttribute = @{ NSFontAttributeName: [UIFont systemFontOfSize:15] };
    UIBarButtonItem *itemAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [itemAppearance setTitleTextAttributes:navTitleAttribute forState:UIControlStateNormal];

    [[UISearchBar appearance] setBackgroundImage:[RFDrawImage imageWithSizeColor:CGSizeMake(1, 44) fillColor:[UIColor whiteColor]]];
    [[UISearchBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_bar_bg"] forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor globalTextColor] } forState:UIControlStateNormal];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    return [self application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options];
}

#endif // END ndef DEMO

#pragma mark - 通用事件监听

- (NSHashTable *)eventListeners {
    if (_eventListeners) return _eventListeners;
    _eventListeners = [NSHashTable weakObjectsHashTable];
    return _eventListeners;
}

- (void)addAppEventListener:(nullable id<UIApplicationDelegate>)listener {
    [self.eventListeners addObject:listener];
}

- (void)removeAppEventListener:(nullable id<UIApplicationDelegate>)listener {
    [self.eventListeners removeObject:listener];
}

#define _app_delegate_event_notice1(SELECTOR)\
    NSArray *all = [self.eventListeners allObjects];\
    for (id<UIApplicationDelegate> listener in all) {\
        if ([listener respondsToSelector:@selector(SELECTOR:)]) {\
            [listener SELECTOR:application];\
        }\
    }\

#define _app_delegate_event_notice2(SELECTOR, PARAMETER1)\
    NSArray *all = [self.eventListeners allObjects];\
    for (id<UIApplicationDelegate> listener in all) {\
        if ([listener respondsToSelector:@selector(application:SELECTOR:)]) {\
            [listener application:application SELECTOR:PARAMETER1];\
        }\
    }

#define _app_delegate_event_method(SELECTOR) \
    - (void)SELECTOR:(UIApplication *)application {\
        _app_delegate_event_notice1(SELECTOR) }

#define _app_delegate_event_method2(SELECTOR) \
    - (void)application:(UIApplication *)application SELECTOR:(id)obj {\
        _app_delegate_event_notice2(SELECTOR, obj) }

_app_delegate_event_method(applicationDidFinishLaunching)

_app_delegate_event_method(applicationWillResignActive)

_app_delegate_event_method(applicationDidReceiveMemoryWarning)
_app_delegate_event_method(applicationSignificantTimeChange)

_app_delegate_event_method(applicationProtectedDataWillBecomeUnavailable)
_app_delegate_event_method(applicationProtectedDataDidBecomeAvailable)

#pragma mark 推送事件

_app_delegate_event_method2(didFailToRegisterForRemoteNotificationsWithError)
_app_delegate_event_method2(didReceiveLocalNotification)
_app_delegate_event_method2(didRegisterUserNotificationSettings)
_app_delegate_event_method2(didRegisterForRemoteNotificationsWithDeviceToken)

#ifndef DEMO
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    _app_delegate_event_notice2(didReceiveRemoteNotification, userInfo)
    if ([userInfo valueForKeyPath:@"aps.content-available"]) {
        // 进行后台操作，完成调用 handler
    }
    dispatch_after_seconds(30, ^{
        handler(arc4random_uniform(2)? UIBackgroundFetchResultNewData : UIBackgroundFetchResultNoData);
    });
}
#endif // ndef DEMO

#pragma mark 其他做了额外事的通知

- (void)applicationWillTerminate:(UIApplication *)application {
    _app_delegate_event_notice1(applicationWillTerminate)
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [AppEnv() setFlagOff:MBENVAppInForeground];
    _applicationLastEnterBackgroundTime = CFAbsoluteTimeGetCurrent();
    _app_delegate_event_notice1(applicationDidEnterBackground)
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    _applicationLastEnterForegroundTime = CFAbsoluteTimeGetCurrent();
    [self tryResumeLaunch];
    _app_delegate_event_notice1(applicationWillEnterForeground)
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [AppEnv() setFlagOn:MBENVAppInForeground];
    _applicationLastBecomeActiveTime = CFAbsoluteTimeGetCurrent();
    AppUserDefaultsShared().applicationLastBecomeActiveTime = [NSDate date];
    [self tryResumeLaunch];
    _app_delegate_event_notice1(applicationDidBecomeActive)
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    completionHandler();
}

#pragma mark -

+ (void)viewAppInAppStore {
    NSString *storeURL = @"itms-apps://itunes.apple.com/app/id915390036";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storeURL]];
}

@end
