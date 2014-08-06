/*!
    APIUserPlugin
    v 2.0

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFPlugin.h"
#import "UserInformation.h"

/// 用 Keychian 存取用户密码
#ifndef APIUserPluginUsingKeychainToStroeSecret
#   define APIUserPluginUsingKeychainToStroeSecret 0
#endif

#if APIUserPluginUsingKeychainToStroeSecret
#import "SSKeychain.h"
#endif

@class API, AFHTTPRequestOperation;

/**
 用户插件，用于添加用户支持
 */
@interface APIUserPlugin : NSObject <
    RFInitializing
>

#pragma mark - 用户信息
@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *password;

/// 临时验证码
@property (copy, nonatomic) NSString *verifyCode;

/// 除上面几个字段外，其余所有信息请定义在该属性中
@property (strong, nonatomic) UserInformation *information;

#pragma mark - 设置
/// 保持登录状态，下次启动不走登录流程。默认 `NO`
@property (assign, nonatomic) BOOL shouldKeepLoginStatus;

/// Default `NO`
@property (assign, nonatomic) BOOL shouldRememberPassword;

/// Default `NO`
@property (assign, nonatomic) BOOL shouldAutoLogin;

/// Default `NO`
@property (assign, nonatomic) BOOL shouldAutoFetchOtherUserInformationAfterLogin;

/// account, password, shouldRememberPassword 等字段保存/重置
- (void)saveProfileConfig;
- (void)resetProfileConfig;

#pragma mark -
#pragma mark 注册

/// 获取手机验证码
- (void)signUpVerifyFromViewController:(id)viewController phone:(NSString *)phone success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/// 验证手机验证码
- (void)signUpVerifyFromViewController:(id)viewController phone:(NSString *)phone code:(NSString *)code success:(void (^)(void))success completion:(void (^)(void))completion;

/// 注册
- (void)signUpFromViewController:(id)viewController name:(NSString *)userName password:(NSString *)password avatar:(UIImage *)image success:(void (^)(void))success completion:(void (^)(void))completion;

#pragma mark 登陆

/// 是否已登入
@property (readonly, nonatomic) BOOL loggedIn;

/// 正在登入
@property (readonly, nonatomic) BOOL logining;

- (void)loginFromViewController:(id)viewController account:(NSString *)account password:(NSString *)password success:(void (^)(void))success completion:(void (^)(void))completion;
- (void)logout;

#pragma mark 用户信息获取
@property (readonly, nonatomic) BOOL fetchingUserInformation;

- (void)fetchUserInfoFromViewController:(id)viewController success:(void (^)(void))success completion:(void (^)(void))completion;

#pragma mark 找回密码
- (void)resetPasswordWithInfo:(NSDictionary *)recoverInfo completion:(void (^)(NSString *password, NSError *error))callback;

@end
