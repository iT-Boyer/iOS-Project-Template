
#import "MBApp.h"
#import "CommonUI.h"
#import "DataStack.h"

@implementation MBApp

+ (instancetype)status {
	static MBApp *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSUserDefaults *ud = AppUserDefaultsShared();
        NSString *json = ud.debugConfigJSON;
        DebugConfig *dc = [[DebugConfig alloc] initWithString:json error:nil];
        _debugConfig = dc?: [DebugConfig new];
        
        { // 版本设置
            NSString *v = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
            _version = v;
            
            NSString *lastVersion = ud.lastVersion;
            // 全新启动
            if (!lastVersion) {
                // 一天内重新安装，通知会保留，需要清掉
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
            }
            // 升级
            else if (![_version isEqualToString:lastVersion]) {
                _previousVersion = lastVersion;
//                [MBAnalytics startFabric];
//                [MBAnalytics logEventWithName:@"TI_AppUpdate" attributes:@{
//                                                                           @"之前版本" : _previousVersion?: @"NA",
//                                                                           @"启动次数": @(ud.launchCountCurrentVersion),
//                                                                           @"总启动次数": @(ud.launchCount),
//                                                                           @"Foundation": [NSString stringWithFormat:@"%f", NSFoundationVersionNumber],
//                                                                           }];
                ud.previousVersion = _previousVersion;
                ud.launchCountCurrentVersion = 0;
            }
            
            ud.lastVersion = _version;
            if (!AppInBackground()) {
                ud.launchCount++;
                ud.launchCountCurrentVersion++;
            }
        }
        _env = [MBEnvironment new];
        [MBEnvironment setAsApplicationDefaultEnvironment:_env];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [self performSelector:@selector(afterInit) withObject:self afterDelay:0];
    }
    return self;
}

- (void)afterInit {
    [self api];
#if DEBUG
// @TODO
//    if (self.debugConfig.showFlexWhenLaunch) {
//        [[FLEXManager sharedManager] showExplorer];
//    }
    
    __weak DebugConfig *dc = self.debugConfig;
    
    if (!dc.debugServer
        && !dc.disableNoticeSwithToDebugServer) {
//        PSTAlertAction *switchAction = [PSTAlertAction actionWithTitle:@"切换" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
//            dc.debugServer = YES;
//            [dc synchronize];
//            exit(0);
//        }];
//
//        void (^showAlertBlock)(NSString *, NSString *, void (^)(PSTAlertAction *)) = ^(NSString *title, NSString *nextTitle, void (^nextAction)(PSTAlertAction *)) {
//            PSTAlertController *ac = [PSTAlertController alertWithTitle:@"注意" message:title];
//            [ac addAction:switchAction];
//            [ac addAction:[PSTAlertAction actionWithTitle:nextTitle style:PSTAlertActionStyleDefault handler:nextAction]];
//            [ac showWithSender:nil controller:nil animated:YES completion:nil];
//        };
//
//        showAlertBlock(@"你正在使用开发版本但处于生产环境\n需要切换到测试服务器吗？\n(调试菜单可禁用本提示)", @"暂不", ^(PSTAlertAction *action1) {
//            showAlertBlock(@"开发版产生的不完善数据可能会污染线上环境并导致严重后果", @"下一步", ^(PSTAlertAction *action2) {
//                showAlertBlock(@"你仍确定的要处于生产环境吗", @"确定", nil);
//            });
//        });
    }
#endif
    
    if (self.previousVersion) {
        [self migrateFromVersion:self.previousVersion];
    }
}


- (BOOL)isNewVersion:(NSString *)version {
    return ([self.version compare:version options:NSNumericSearch] == NSOrderedAscending);
}

- (void)migrateFromVersion:(NSString *_Nonnull)previousVersion {
#ifndef DEMO
    NSParameterAssert(previousVersion);
    NSUserDefaults *ud = AppUserDefaultsShared();
    
    // 前面的版本写当前版本
//    if ([@"2.6.0" compare:previousVersion options:NSNumericSearch] == NSOrderedDescending) {
//        [ud removeObjectForKey:@"Last Pedometer Data Sync Time"];
//    }
    [ud synchronize];
#endif // ndef DEMO
}

#pragma mark -

- (API *)api {
    if (!API.global) {
        API.global = [API new];
        API.global.networkActivityIndicatorManager = self.hud;
    }
    return API.global;
}

@synthesize hud = _hud;
- (MessageManager *)hud {
    if (!_hud) {
        _hud = [MessageManager new];
    }
    return _hud;
}

- (MBDataStack *)dataStack {
    if (!_dataStack) {
        _dataStack = [MBDataStack new];
    }
    return _dataStack;
}


#pragma mark - 其他业务

- (void)onReceiveMemoryWarning {
//    [[SDImageCache sharedImageCache] clearMemory];
}

@end
