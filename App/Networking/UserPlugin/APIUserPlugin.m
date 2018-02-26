
#import "APIUserPlugin.h"
#import "API.h"
#import "debug.h"

NSString *const UDkLastUserAccount      = @"Last User Account";
NSString *const UDkUserPass             = @"User Password";
NSString *const UDkUserRemeberPass      = @"Should Remember User Password";
NSString *const UDkUserInformation      = @"User Information";

@interface APIUserPlugin ()
@property (readwrite, nonatomic) BOOL loggedIn;
@property (readwrite, nonatomic) BOOL logining;
@property (readwrite, nonatomic) BOOL fetchingUserInformation;

@end

@implementation APIUserPlugin
RFInitializingRootForNSObject

- (void)onInit {
    [self loadProfileConfig];

    if (!self.information) {
        self.information = [UserInformation new];
    }

    if (DebugAPISkipLogin) {
        self.loggedIn = YES;
    }

    if (self.account.length && self.password.length) {
        if (!DebugAPINoAutoLogin) {
            self.loggedIn = YES;
            [self fetchUserInfoFromViewController:nil success:nil completion:nil];
        }
    }
}

- (void)afterInit {
    
}

#pragma mark - 注册

- (void)signUpVerifyFromViewController:(id)viewController phone:(NSString *)phone success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSParameterAssert(phone.length);
    [API requestWithName:@"SignUpVerify" parameters:@{ @"phone" : phone } viewController:viewController forceLoad:NO loadingMessage:@"" modal:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.account = phone;
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    } completion:nil];
}

- (void)signUpVerifyFromViewController:(id)viewController phone:(NSString *)phone code:(NSString *)code success:(void (^)(void))success completion:(void (^)(void))completion {
    NSParameterAssert(phone);
    NSParameterAssert(code);
    [API requestWithName:@"SignUpVerifyCheck" parameters:@{ @"phone" : phone, @"code" : code } viewController:viewController loadingMessage:@"验证中" modal:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.verifyCode = code;
        self.account = phone;
        if (success) {
            success();
        }
    } completion:^(AFHTTPRequestOperation *operation) {
        if (completion) {
            completion();
        }
    }];
}

- (void)signUpFromViewController:(id)viewController name:(NSString *)userName password:(NSString *)password avatar:(UIImage *)image success:(void (^)(void))success completion:(void (^)(void))completion {
    self.password = [self passHashWithString:password];
    RFAssert(false, @"按需完成具体实现");
}

#pragma mark - 登入

- (void)loginFromViewController:(id)viewController account:(NSString *)account password:(NSString *)password success:(void (^)(void))success completion:(void (^)(void))completion {
    NSParameterAssert(account);
    NSParameterAssert(password);

    self.logining = YES;
    [API requestWithName:@"Login" parameters:@{
        @"account" : self.account,
        @"password" : self.password
    } viewController:viewController forceLoad:NO loadingMessage:@"登录中" modal:NO success:^(AFHTTPRequestOperation *operation, id responseObject) {

        self.account = account;
        self.password = [self passHashWithString:password];
        self.loggedIn = YES;

        [self saveProfileConfig];
        if (self.shouldAutoFetchOtherUserInformationAfterLogin) {
            [self fetchUserInfoFromViewController:viewController success:success completion:completion];
        }
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[API sharedInstance].networkActivityIndicatorManager alertError:error title:@"登录失败"];
    } completion:^(AFHTTPRequestOperation *operation) {
        self.logining = NO;
        if (completion) {
            completion();
        }
    }];
}

- (void)logout {
    self.loggedIn = NO;
    [self resetProfileConfig];

    // 其他清理
}

- (void)setLoggedIn:(BOOL)loggedIn {
    _loggedIn = loggedIn;

    // 更新身份认证信息
}

#pragma mark -

- (void)fetchUserInfoFromViewController:(id)viewController success:(void (^)(void))success completion:(void (^)(void))completion {
    [API requestWithName:@"UserInfo" parameters:nil viewController:viewController loadingMessage:@"获取信息中" modal:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.information = responseObject;
        [self saveProfileConfig];
        if (success) {
            success();
        }
    } completion:^(AFHTTPRequestOperation *operation) {
        if (completion) {
            completion();
        }
    }];
}


#pragma mark -
- (void)resetPasswordWithInfo:(NSDictionary *)recoverInfo completion:(void (^)(NSString *password, NSError *error))callback {

	RFAPIControl *cn = [[RFAPIControl alloc] initWithIdentifier:APINameResetPassword loadingMessage:@"提交重置密码请求..."];
	cn.message.modal = YES;
	[[API sharedInstance] requestWithName:APINameResetPassword parameters:recoverInfo controlInfo:cn success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            callback(responseObject, nil);
        }
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback(nil, error);
        }
	} completion:nil];
}

#pragma mark - Secret staues

- (NSString *)passHashWithString:(NSString *)pass {
    return [NSString MD5String:pass];
}

- (void)loadProfileConfig {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.shouldRememberPassword = [ud boolForKey:UDkUserRemeberPass];
    self.account = [ud objectForKey:UDkLastUserAccount];
    self.information = [[UserInformation alloc] initWithString:[ud objectForKey:UDkUserInformation] error:nil];

    // 根据信息恢复其他登录状态

    if (self.shouldRememberPassword) {
#if APIUserPluginUsingKeychainToStroeSecret
        NSError __autoreleasing *e = nil;
        self.userPassword = [SSKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:self.userAccount error:&e];
        if (e) dout_error(@"%@", e);
#else
        self.password = [[NSUserDefaults standardUserDefaults] objectForKey:UDkUserPass];
#endif
    }
}

- (void)saveProfileConfig {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.account forKey:UDkLastUserAccount];
    [ud setBool:self.shouldRememberPassword forKey:UDkUserRemeberPass];

#if APIUserPluginUsingKeychainToStroeSecret
    if (self.shouldRememberPassword) {
        NSError __autoreleasing *e = nil;
        [SSKeychain setPassword:self.userPassword forService:[NSBundle mainBundle].bundleIdentifier account:self.userAccount error:&e];
        if (e) dout_error(@"%@", e);
    }
    else {
        [SSKeychain deletePasswordForService:[NSBundle mainBundle].bundleIdentifier account:self.userAccount];
    }
#else
    if (self.shouldRememberPassword) {
        [ud setObject:self.password forKey:UDkUserPass];
    }
    else {
        [ud removeObjectForKey:UDkUserPass];
    }
#endif
    
    [ud synchronize];
}

- (void)resetProfileConfig {
    self.password = nil;
    self.information = nil;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:UDkUserRemeberPass];
    [ud removeObjectForKey:UDkUserPass];
    [ud removeObjectForKey:UDkLastUserAccount];
    [ud removeObjectForKey:UDkUserInformation];
    [ud synchronize];
    
#if APIUserPluginUsingKeychainToStroeSecret
    [SSKeychain deletePasswordForService:[NSBundle mainBundle].bundleIdentifier account:self.userAccount];
#endif
}

@end
