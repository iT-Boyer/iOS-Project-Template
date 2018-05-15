
#import "APApplicationDelegate.h"
#import "MBApp.h"
#import <RFKeyboard/RFKeyboard.h>

@interface APApplicationDelegate () <
    UIApplicationDelegate
>
@end

@implementation APApplicationDelegate

#pragma mark - Launch

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AppUserDefaultsShared().applicationLastLaunchTime = [NSDate date];
    [MBApp status];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    // 第一次，或上次未成功启动
    NSUserDefaults *ud = AppUserDefaultsShared();
    if (!ud.launchGuard) {
        // 上次启动可能出问题了，开统计
        //            [MBAnalytics startFabric];
    }
    ud.launchGuard = NO;
    
    // 3s 后认为应用这次启动成功了
    dispatch_after_seconds(3, ^{
        AppUserDefaultsShared().launchGuard = YES;
    });

    if (AppDebugConfig().debugMode) {
        if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
            DebugLog(NO, nil, @"后台地址启动");
        }
    }
    [APUser setup];
    
    // 全局点击空白隐藏键盘
    RFKeyboard.autoDisimssKeyboardWhenTouch = YES;
    [self generalAppearanceSetup];
    return YES;
}

- (void)generalAppearanceSetup {
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor globalTintColor];

    NSDictionary *navTitleAttribute = @{ NSFontAttributeName: [UIFont systemFontOfSize:15] };
    UIBarButtonItem *itemAppearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[ UINavigationBar.class ]];
    [itemAppearance setTitleTextAttributes:navTitleAttribute forState:UIControlStateNormal];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [AppEnv() setFlagOn:MBENVAppInForeground];
    [AppEnv() setFlagOn:MBENVAppHasEnterForegroundOnce];
    [super applicationDidBecomeActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [AppEnv() setFlagOff:MBENVAppInForeground];
    [super applicationDidEnterBackground:application];
}

@end
