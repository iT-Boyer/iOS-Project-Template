
#import "APIUserPlugin.h"
#import "MBApp.h"
#import "MBAnalytics.h"

@interface APIUserPlugin ()
@property (readwrite, nonatomic) BOOL logining;
@end

@implementation APIUserPlugin
RFInitializingRootForNSObject

- (void)onInit {
    [self loadProfileConfig];
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
    [API requestWithName:@"SignUpVerifyCheck" parameters:@{ @"phone" : phone, @"code" : code } viewController:viewController forceLoad:NO loadingMessage:@"验证中" modal:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.verifyCode = code;
        self.account = phone;
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (!error) {
            [API alertError:nil title:@"验证码输入错误"];
        }
        else {
            [API alertError:error title:@"请求失败"];
        }
    } completion:^(AFHTTPRequestOperation *operation) {
        if (completion) {
            completion();
        }
    }];
}

- (void)signUpFromViewController:(id)viewController name:(NSString *)userName sex:(NSString *)sex password:(NSString *)password avatar:(UIImage *)image birthday:(NSString *)birthday success:(void (^)(void))success completion:(void (^)(void))completion {

    NSString *passToken = [self passHashWithString:password];

    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    NSString *imageBase64 = [imageData base64EncodedStringWithOptions:0];

    RFAssert(userName, @"用户名空");
    RFAssert(self.account, @"账户空");
    RFAssert(sex, @"性别空");
    RFAssert(passToken, @"密码空");
    RFAssert(self.verifyCode, @"验证码空");

    NSMutableDictionary *p = [@{
                        @"nick": userName?: @"",
                        @"mobile": self.account?: @"",
                        @"sex": sex?: @"",
                        @"password": passToken?: @"",
                        @"avatar": imageBase64?: [NSNull null],
                        @"code": self.verifyCode?: @"",
                        } mutableCopy];
    if (birthday) {
        p[@"birthday"] = birthday;
    }

    __block BOOL upSuccess = NO;
    [API requestWithName:@"SignUp" parameters:p viewController:viewController loadingMessage:@"注册中" modal:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        upSuccess = YES;
        [self loginFromViewController:nil phone:self.account password:password fromSignup:YES success:^{
            if (success) {
                success();
            }
        } mismatch:nil completion:^{
            if (completion) {
                completion();
            }
        }];
    } completion:^(AFHTTPRequestOperation *operation) {
        if (!upSuccess) {
            if (completion) {
                completion();
            }
        }
    }];
}

- (NSString *)passHashWithString:(NSString *)pass {
    return [NSString stringWithFormat:@"s_+%@", pass].rf_MD5String;
}

#pragma mark - 登入

- (void)loginFromViewController:(id)viewController phone:(NSString *)phone password:(NSString *)password success:(void (^)(void))success mismatch:(void (^)(void))mismatch completion:(void (^)(void))completion {
    [self loginFromViewController:viewController phone:phone password:password fromSignup:NO success:success mismatch:mismatch completion:completion];
}

- (void)loginFromViewController:(id)viewController phone:(NSString *)phone password:(NSString *)password fromSignup:(BOOL)fromSignup success:(void (^)(void))success mismatch:(void (^)(void))mismatch completion:(void (^)(void))completion {
    NSParameterAssert(phone);
    NSParameterAssert(password);
    // 这里设成 None 以强制切换
    NSURLCredential *cre = [NSURLCredential credentialWithUser:phone password:[self passHashWithString:password] persistence:NSURLCredentialPersistenceNone];

    self.logining = YES;
    
    AFHTTPRequestOperation *op = [API requestWithName:@"Login" parameters:nil viewController:viewController forceLoad:NO loadingMessage:@"登录中" modal:YES success:^(AFHTTPRequestOperation *operation, UserInformation *responseObject) {

        self.account = phone;
        [self saveProfileConfig];

        MBUser *user = [[MBUser alloc] initWithID:responseObject.uid];
        user.token = responseObject.token;
        user.information = responseObject;
        user.hasLoginedThisSession = YES;
        [user save];
        [MBUser setCurrentUser:user];

        if (success) {
            success();
        }
        [MBAnalytics logLoginWithMethod:@"手机" success:@(YES) attributes:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.domain == APIErrorDomain && error.code == 401) {
            if (mismatch) {
                mismatch();
            }
            [MBAnalytics logLoginWithMethod:@"手机" success:@(NO) attributes:@{ @"Error" : @"密码错误" }];
            return;
        }
        [MBAnalytics logLoginWithMethod:@"手机" success:@(NO) attributes:@{ @"Error" : error }];
        [API alertError:error title:@"登录失败"];
    } completion:^(AFHTTPRequestOperation *operation) {
        self.logining = NO;

        if (completion) {
            completion();
        }
    }];
    op.credential = cre;
}

#pragma mark -
- (void)resetPasswordFromViewController:(id)viewController info:(NSDictionary *)recoverInfo success:(void (^)(void))callback {
    NSMutableDictionary *p = [recoverInfo mutableCopy];
    p[@"pwd"] = [self passHashWithString:p[@"pwd"]];

    [API requestWithName:@"PasswordReset" parameters:p viewController:viewController loadingMessage:@"修改密码中……" modal:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            callback();
        }
    } completion:nil];
}

#pragma mark - Secret staues
- (void)loadProfileConfig {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.account = ud.userAccount;
}

- (void)saveProfileConfig {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    ud.userAccount = self.account;
    [ud synchronize];
}

- (void)resetProfileConfig {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    ud.userToken = nil;
    ud.userAccount = nil;
    ud.userInformation = nil;
    [ud synchronize];
}

@end
