
#import "Account.h"
#import "API.h"
#import "MBApp.h"
#import "AccountEntity.h"
#import "Common.h"

@interface Account ()
#if MBUserStringUID
@property (readwrite) MBIdentifier uid;
#else
@property (readwrite) MBID uid;
#endif
@end

@implementation Account
@dynamic uid;

+ (void)onCurrentUserChanged:(Account *)user {
    NSUserDefaults *ud = AppUserDefaultsShared();
    ud.lastUserID = user.uid;
    ud.userToken = user.token;
    ud.AccountEntity = user.information.toJSONString;
    BOOL success = ud.synchronize;
    if (!success) {
        dispatch_after_seconds(0, ^{
            if (AppUserDefaultsShared().synchronize) return;
            
            DebugLog(YES, @"UDSynchronizeFail", @"用户信息存储失败");
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系统错误" message:@"暂时不能保存您的用户信息，如果你反复遇到这个提示，建议您重启设备以解决这个问题" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"本次启动不再提示" style:UIAlertActionStyleDefault handler:nil]];
                [UIViewController.rootViewControllerWhichCanPresentModalViewController presentViewController:alert animated:YES completion:nil];
            });
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
    dout_info(@"当前用户 ID: %@, token: %@", @(self.uid), self.token);
    AppAPI().defineManager.authorizationHeader[@"token"] = self.token;
}

- (void)onLogout {
    [AppAPI().defineManager.authorizationHeader removeObjectForKey:@"token"];
    [self resetCookies];
    [self.profile synchronize];
}

#pragma mark - init

+ (void)setup {
    if (AppUser()) return;

    NSUserDefaults *ud = AppUserDefaultsShared();
    if (!ud.lastUserID) return;

    Account *user = [[self alloc] initWithID:ud.lastUserID];
    if (!user.token.length) {
        DebugLog(YES, @"LaunchUserNoToken", @"Account has ID but no token");
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
    BOOL debugServer = NO;
#if MBUserStringUID
    NSString *suitName = [NSString stringWithFormat:@"User%@%@", self.uid, debugServer? @"D" : @""].rf_MD5String;
#else
    NSString *suitName = [NSString stringWithFormat:@"User%lld%@", self.uid, debugServer? @"D" : @""].rf_MD5String;
#endif
    _profile = [NSAccountDefaults.alloc initWithSuiteName:suitName];

    NSUserDefaults *ud = AppUserDefaultsShared();
    _token = ud.userToken;
}

#pragma mark -

@synthesize information = _information;
- (AccountEntity *)information {
    @synchronized(self) {
        if (_information) return _information;
        NSUserDefaults *ud = AppUserDefaultsShared();
        AccountEntity *ui = [AccountEntity.alloc initWithString:ud.AccountEntity error:nil];
        if (!ui) {
            ud.AccountEntity = nil;
            ui = AccountEntity.new;
        }
        _information = ui;
        return _information;
    }
}
- (void)setInformation:(AccountEntity *)information {
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
        // 原则是保留能从用户信息接口获取的字段，如果是登录接口附加的信息则移动到 Account 上
        
        
#if DEBUG
        // 验证一些假设
        
#endif
        if (self.isCurrent) {
            AppUserDefaultsShared().AccountEntity = self.information.toJSONString;
        }
    }
}

#pragma mark -

- (void)updateInformationFromViewController:(UIViewController *)viewController complation:(MBGeneralCallback)complation {
    __block MBGeneralCallback callback = complation;
    if (!callback && viewController) {
        callback = ^(BOOL success, id _Nullable item, NSError *_Nullable error){
            if (error) {
                [AppHUD() alertError:error title:nil fallbackMessage:nil];
            }
        };
    }
    
    NSMutableDictionary *att = [NSMutableDictionary dictionaryWithCapacity:3];
    [API.global requestWithName:@"AcoountInfo" context:^(RFAPIRequestConext *c) {
        c.parameters = att;
        c.success = ^(id<RFAPITask>  _Nonnull task, AccountEntity *rsp) {
            self.hasLoginedThisSession = YES;
            self.information = rsp;

            if (self.isCurrent) {
                [AppEnv() setFlagOn:MBENVFlagUserInfoFetched];
            }
        };
        if (callback) {
            c.finished = ^(id<RFAPITask>  _Nullable task, BOOL success) {
                callback(success, self.information, task.error);
            };
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
