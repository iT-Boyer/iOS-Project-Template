
#import "APUser.h"
#import "APINetworkActivityManager.h"
#import "DataStack.h"
#import "MBApp.h"
#import "APUserInfo.h"

@interface APUser ()
@property (readwrite) MBID uid;
@end

@implementation APUser
@dynamic uid;

+ (void)onCurrentUserChanged:(APUser *)user {
    NSUserDefaults *ud = AppUserDefaultsShared();
    ud.lastUserID = user.uid;
    ud.userToken = user.token;
    [ud synchronize];
    if (user) {
        [AppEnv() setFlagOn:MBENVUserHasLogged];
    }
    else {
        [AppEnv() setFlagOff:MBENVUserHasLogged];
        [AppEnv() setFlagOff:MBENVUserInfoFetched];
    }
}

- (void)onLogin {
    dout_info(@"当前用户 token 为: %@", self.token);
    API.global.defineManager.authorizationHeader[@"feeltoken"] = self.token;
}

- (void)onLogout {
    [API.global.defineManager.authorizationHeader removeObjectForKey:@"feeltoken"];
    [self resetCookies];
    [self.profile synchronize];
}

#pragma mark - init

+ (void)setup {
    if (AppUser()) return;

    NSUserDefaults *ud = AppUserDefaultsShared();
    if (!ud.lastUserID) return;

    APUser *user = [[self alloc] initWithID:ud.lastUserID];
    if (user.token.length) {
        [self setCurrentUser:user];
    }
    else {
        DebugLog(YES, @"LaunchUserNoToken", @"APUser has ID but no token");
    }
}

- (void)onInit {
    [super onInit];
    BOOL debugServer = AppDebugConfig().debugServer;
    NSString *suitName = [NSString stringWithFormat:@"User%ld%@", self.uid, debugServer? @"D" : @""].rf_MD5String;
    _profile = [NSAccountDefaults.alloc initWithSuiteName:suitName];

    NSUserDefaults *ud = AppUserDefaultsShared();
    DebugConfig *dc = AppDebugConfig();
    if (dc.bindUserInfoToServer) {
        _information = (dc.debugServer)? dc.developUserInformation : dc.productionUserInformation;
    }
    else {
        _information = [[APUserInfo alloc] initWithString:ud.APUserInfo error:nil];
    }

    if (dc.bindUserInfoToServer) {
        _token = dc.debugServer? dc.developToken : dc.productionToken;
    }
    else {
        _token = ud.userToken;
    }
}

#pragma mark -

- (void)setInformation:(APUserInfo *)information {
    if (_information) {
        // 新获取的字段经常会是部分的，需要补全一下
        
    }

    _information = information;
    if (!information) {
        RFAssert(false, @"正常不会置空");
        return;
    }
    if (information.uid
        && self.uid != information.uid) {
        DebugLog(YES, @"MBUserInformationIDMismatch", @"用户信息 ID 不匹配");
        self.uid = information.uid;
    }
    if (information.token) {
        self.token = information.token;
    }

    // 开始对接口/数据源取回的数据处理
    // 原则是保留能从用户信息接口获取的字段，如果是登录接口附加的信息则移动到 APUser 上


#if DEBUG
    // 验证一些假设

#endif
}

@synthesize storage = _storage;
- (RLMRealm *)storage {
    if (_storage) return _storage;

    MBDataStack *ds = [MBApp status].dataStack;
    _storage = [ds realmWithURL:({
        NSString *suitName = [NSString stringWithFormat:@"User%ld%@.db", AppUserID(), AppDebugConfig().debugServer? @"D" : @""];
        [ds.realmDirURL URLByAppendingPathComponent:suitName];
    })];
    return _storage;
}

- (void)writeStorage:(void (^)(RLMRealm *__nonnull))block {
    NSParameterAssert(block);
    dispatch_sync_on_main(^{
        RLMRealm *s = self.storage;
        if (s.inWriteTransaction) {
            block(s);
        }
        else {
            [s beginWriteTransaction];
            block(s);
            NSError __autoreleasing *e = nil;
            [s commitWriteTransaction:&e];
            if (e) dout_error(@"%@", e);
        }
    });
}

#pragma mark -

- (void)updateInformationFromViewController:(UIViewController *)viewController complation:(MBGeneralCallback)complation {
    __block MBGeneralCallback callback = complation;
    if (!callback
        && viewController
        ) {
        callback = ^(BOOL success, id _Nullable item, NSError *_Nullable error){
            if (error) {
                [AppHUD() alertError:error title:nil];
            }
        };
    }
    
    NSMutableDictionary *att = [NSMutableDictionary dictionaryWithCapacity:3];
    att[@"uid"] = @(self.uid);
    // 注意：UserInfo 和 Login 返回的字段不一样
    [API requestWithName:self.hasLoginedThisSession? @"UserInfoMine" : @"Login" parameters:att viewController:viewController forceLoad:YES loadingMessage:nil modal:NO success:^(AFHTTPRequestOperation *operation, APUserInfo *responseObject) {
        self.hasLoginedThisSession = YES;
        self.information = responseObject;
        [self save];
        if (self.isCurrent) {
            [AppEnv() setFlagOn:MBENVUserInfoFetched];
        }

        if (callback) {
            callback(YES, self.information, nil);
            callback = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback(NO, nil, error);
            callback = nil;
        }
    } completion:^(AFHTTPRequestOperation *operation) {
        if (callback) {
            callback(NO, nil, operation.error);
        }
    }];
}

- (void)save {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    ud.APUserInfo = self.information.toJSONString;
    if (self.isCurrent) {
        ud.lastUserID = self.uid;
        ud.userToken = self.token;
    }
    BOOL success = ud.synchronize;
    if (!success) {
        if (NSUserDefaults.standardUserDefaults.synchronize) {
            return;
        }
        DebugLog(YES, @"UDSynchronizeFail", @"用户信息存储失败");
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [UIAlertView showWithTitle:@"系统错误" message:@"暂时不能保存您的用户信息，如果你反复遇到这个提示，建议您重启 iPhone 以解决这个问题" buttonTitle:@"本次启动不再提示"];
        });
    }
}

- (void)resetCookies {
    NSHTTPCookieStorage *cs = NSHTTPCookieStorage.sharedHTTPCookieStorage;
    [cs.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cs deleteCookie:obj];
    }];
}

@end
