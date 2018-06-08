
#import "APUser.h"
#import "MBApp.h"
#import "APUserInfo.h"
#import "CommonUI.h"

@interface APUser ()
#if MBUserStringUID
@property (readwrite) MBIdentifier uid;
#else
@property (readwrite) MBID uid;
#endif
@end

@implementation APUser
@dynamic uid;

+ (void)onCurrentUserChanged:(APUser *)user {
    NSUserDefaults *ud = AppUserDefaultsShared();
    ud.lastUserID = user.uid;
    ud.userToken = user.token;
    ud.APUserInfo = user.information.toJSONString;
    BOOL success = ud.synchronize;
    if (!success) {
        if (NSUserDefaults.standardUserDefaults.synchronize) {
            return;
        }
        DebugLog(YES, @"UDSynchronizeFail", @"用户信息存储失败");
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系统错误" message:@"暂时不能保存您的用户信息，如果你反复遇到这个提示，建议您重启设备以解决这个问题" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"本次启动不再提示" style:UIAlertActionStyleDefault handler:nil]];
            [UIViewController.rootViewControllerWhichCanPresentModalViewController presentViewController:alert animated:YES completion:nil];
        });
    }
    if (user) {
        [AppEnv() setFlagOn:MBENVFlagUserHasLogged];
    }
    else {
        [AppEnv() setFlagOff:MBENVFlagUserHasLogged];
        [AppEnv() setFlagOff:MBENVFlagUserInfoFetched];
    }
}

- (void)onLogin {
    dout_info(@"当前用户 token 为: %@", self.token);
    AppAPI().defineManager.authorizationHeader[@"Authorization"] = [NSString stringWithFormat:@"Bearer %@", self.token];
}

- (void)onLogout {
    [AppAPI().defineManager.authorizationHeader removeObjectForKey:@"Authorization"];
    [self resetCookies];
    [self.profile synchronize];
}

#pragma mark - init

+ (void)setup {
    if (AppUser()) return;

    NSUserDefaults *ud = AppUserDefaultsShared();
    if (!ud.lastUserID) return;

    APUser *user = [[self alloc] initWithID:ud.lastUserID];
    if (!user.token.length) {
        DebugLog(YES, @"LaunchUserNoToken", @"APUser has ID but no token");
        return;
    }
    [self setCurrentUser:user];
        
    [API backgroundRequestWithName:@"AccountRefresh" parameters:nil completion:^(BOOL success, id  _Nullable responseObject, NSError * _Nullable error) {
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            return;
        }
        NSString *newToken = responseObject[@"token"];
        if (![newToken isKindOfClass:NSString.class]
            || !user.isCurrent) return;
        if (![user.token isEqualToString:newToken]) {
            user.token = newToken;
            [user onLogin];
            AppUserDefaultsShared().userToken = newToken;
        }
        [user updateInformationFromViewController:nil complation:nil];
    }];
    RFAssert(API.global, @"");
}

- (void)onInit {
    [super onInit];
    BOOL debugServer = AppDebugConfig().debugServer;
#if MBUserStringUID
    NSString *suitName = [NSString stringWithFormat:@"User%@%@", self.uid, debugServer? @"D" : @""].rf_MD5String;
#else
    NSString *suitName = [NSString stringWithFormat:@"User%ld%@", self.uid, debugServer? @"D" : @""].rf_MD5String;
#endif
    _profile = [NSAccountDefaults.alloc initWithSuiteName:suitName];

    NSUserDefaults *ud = AppUserDefaultsShared();
    _token = ud.userToken;
}

#pragma mark -

@synthesize information = _information;
- (APUserInfo *)information {
    @synchronized(self) {
        if (_information) return _information;
        NSUserDefaults *ud = AppUserDefaultsShared();
        APUserInfo *ui = [APUserInfo.alloc initWithString:ud.APUserInfo error:nil];
        if (!ui) {
            ud.APUserInfo = nil;
            ui = APUserInfo.new;
        }
        _information = ui;
        return _information;
    }
}
- (void)setInformation:(APUserInfo *)information {
    @synchronized(self) {
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
            if (self.isCurrent) {
                AppUserDefaultsShared().lastUserID = self.uid;
            }
        }
        
        // 开始对接口/数据源取回的数据处理
        // 原则是保留能从用户信息接口获取的字段，如果是登录接口附加的信息则移动到 APUser 上
        
        
#if DEBUG
        // 验证一些假设
        
#endif
        if (self.isCurrent) {
            AppUserDefaultsShared().APUserInfo = self.information.toJSONString;
        }
    }
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
    [API requestWithName:@"UserInfo" parameters:att viewController:viewController forceLoad:YES loadingMessage:nil modal:NO success:^(AFHTTPRequestOperation *operation, APUserInfo *responseObject) {
        self.hasLoginedThisSession = YES;
        self.information = responseObject;

        if (self.isCurrent) {
            [AppEnv() setFlagOn:MBENVFlagUserInfoFetched];
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

- (void)resetCookies {
    NSHTTPCookieStorage *cs = NSHTTPCookieStorage.sharedHTTPCookieStorage;
    [cs.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cs deleteCookie:obj];
    }];
}

@end
