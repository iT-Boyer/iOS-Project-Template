//
//  MBUser.h
//  Feel
//
//  Created by BB9z on 6/20/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "MBModel.h"

@class RLMRealm;

@interface MBUser : NSObject <
    RFInitializing
>

#pragma mark - 当前用户

/// 当前已登录的用户，用户未登录返回 nil
+ (nullable instancetype)currentUser;

/// 设置已登录用户，nil 标记为登出
+ (void)setCurrentUser:(nullable MBUser *)user;

typedef void (^MBUserCurrentUserChangeCallback)(MBUser *__nullable currentUser);

/**
 @param initial 是否立即调用回调
 */
+ (void)addCurrentUserChangeObserver:(nonnull id)observer initial:(BOOL)initial callback:(nonnull MBUserCurrentUserChangeCallback)callback;
+ (void)removeCurrentUserChangeObserver:(nullable id)observer;

- (BOOL)isCurrent;

#pragma mark - 状态
typedef void (^MBUserGetCtTokenCallback)(MBUser *__nullable currentUser);
/**
 由 ID 创建用户对象，输入不大于 0 返回 nil
 */
- (nullable instancetype)initWithID:(MBID)uid;

/// 用户 ID
@property (readonly) MBID uid;

/// 除上面几个字段外，其余所有信息请定义在该属性中
@property (nonatomic, nullable, strong) UserInformation *information;

/// 手机登录时用 Digest 验证，其他时候都用 token
@property (nonatomic, nullable, copy) NSString *token;

/// 积分系统请求所需token
@property (nonatomic, nullable, strong) NSString *ectoken;

#pragma mark - 挂载

@property (nonatomic, nullable, readonly) MBUserProfiles *profile;

/// 数据库，懒加载
@property (nonatomic, nonnull, readonly) RLMRealm *storage;

- (void)writeStorage:(NS_NOESCAPE void (^__nonnull)(RLMRealm *__nonnull))block;

#pragma mark - 流程

/// 应用启动后初始流程
+ (void)setup;

@property BOOL hasLoginedThisSession;

/**
 @param complation item 参数是 UserInformation。如果传空且 viewController 非空，默认出错弹窗
 */
- (void)updateInformationFromViewController:(nullable UIViewController *)viewController complation:(nullable MBGeneralCallback)complation;

/// 持久化当前状态
- (void)save;

@end
