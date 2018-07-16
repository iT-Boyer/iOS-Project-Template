
#import "MBApp.h"
#import "Common.h"

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

//@synthesize workerQueue = _workerQueue;
//- (MBWorkerQueue *)workerQueue {
//    if (_workerQueue) return _workerQueue;
//    _workerQueue = [MBWorkerQueue new];
//    return _workerQueue;
//}

//@synthesize backgroundWorkerQueue = _backgroundWorkerQueue;
//- (MBWorkerQueue *)backgroundWorkerQueue {
//    if (_backgroundWorkerQueue) return _backgroundWorkerQueue;
//    _backgroundWorkerQueue = [MBWorkerQueue new];
//    _backgroundWorkerQueue.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    return _backgroundWorkerQueue;
//}

#pragma mark - 其他业务

- (void)onReceiveMemoryWarning {
//    [[SDImageCache sharedImageCache] clearMemory];
}

@end
