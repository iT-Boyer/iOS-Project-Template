
#import "AppDelegate.h"
#import "debug.h"
#import "DataStack.h"
#import "API.h"
#import "UncaughtExceptionHandler.h"
#import "MBRootNavigationController.h"
#import "UIKit+App.h"
#import "SVProgressHUD.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (DebugEnableUncaughtExceptionHandler) {
        InstallUncaughtExceptionHandler();
    }

    // 通用模块设置，按需取消注释以启用
    // 如有可能，需要把模块初始化置后
    [API sharedInstance];

    // Core Data
//    [DataStack sharedInstance];

    // 全局点击空白隐藏键盘
    [RFKeyboard setEnableAutoDisimssKeyboardWhenTouch:YES];

    [self generalAppearanceSetup];
    return YES;
}

- (void)generalAppearanceSetup {
    [[SVProgressHUD appearance] setHudRingForegroundColor:[UIColor globalTintColor]];
}

@end
