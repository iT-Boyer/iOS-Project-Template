/*!
    APIUserPlugin
    v 2.0

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"
#import "UserInformation.h"
#import "NSUserDefaults+App.h"

NS_ASSUME_NONNULL_BEGIN

@class API, AFHTTPRequestOperation;

/**
 用户插件，用于添加用户支持
 */
@interface APIUserPlugin : NSObject <
    RFInitializing
>

#pragma mark - 用户信息

@property (nonatomic, nullable, copy) NSString *account;

/// 临时验证码
@property (nonatomic, nullable, copy) NSString *verifyCode;

#pragma mark - 设置

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
- (void)signUpFromViewController:(id)viewController name:(NSString *)userName sex:(NSString *)sex password:(NSString *)password avatar:(UIImage *)image birthday:(NSString *)birthday success:(void (^)(void))success completion:(void (^)(void))completion;

- (NSString *)passHashWithString:(NSString *)pass;

#pragma mark 登陆

/// 正在登入
@property (readonly, nonatomic) BOOL logining;

- (void)loginFromViewController:(id)viewController phone:(NSString *)phone password:(NSString *)password success:(void (^ _Nullable)(void))success mismatch:(void (^ _Nullable)(void))mismatch completion:(void (^ _Nullable)(void))completion;

#pragma mark 找回密码

- (void)resetPasswordFromViewController:(id _Nullable)viewController info:(NSDictionary *)recoverInfo success:(void (^)(void))callback;

@end

NS_ASSUME_NONNULL_END
