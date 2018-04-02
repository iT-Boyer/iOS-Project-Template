/*!
 APUser
 
 Copyright © 2018 RFUI. All rights reserved.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBUser.h"
#import "Common.h"

@class RLMRealm;

@interface APUser : MBUser

#pragma mark - 状态

/// 除上面几个字段外，其余所有信息请定义在该属性中
@property (nonatomic, nullable, strong) APUserInfo *information;

/// 手机登录时用 Digest 验证，其他时候都用 token
@property (nonatomic, nullable, copy) NSString *token;

/// 积分系统请求所需token
@property (nonatomic, nullable, strong) NSString *ectoken;

#pragma mark - 挂载

@property (nonatomic, nullable, readonly) NSAccountDefaults *profile;

/// 数据库，懒加载
@property (nonatomic, nonnull, readonly) RLMRealm *storage;

- (void)writeStorage:(NS_NOESCAPE void (^__nonnull)(RLMRealm *__nonnull))block;

#pragma mark - 流程

/// 应用启动后初始流程
+ (void)setup;

@property BOOL hasLoginedThisSession;

/**
 @param complation item 参数是 APUserInfo。如果传空且 viewController 非空，默认出错弹窗
 */
- (void)updateInformationFromViewController:(nullable UIViewController *)viewController complation:(nullable MBGeneralCallback)complation;

/// 持久化当前状态
- (void)save;

@end
