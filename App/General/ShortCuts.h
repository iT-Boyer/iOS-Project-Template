//
//  ShortCuts.h
//  Feel
//
//  Created by BB9z on 12/12/15.
//  Copyright © 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//
#import "MBModel.h"

/**
 快速访问一些全局对象

 用函数而不是直接暴露全局变量，为了便于根据情况处理返回值，
 为日后解决模块间初始化依赖做铺垫，还利于调试（设置断点、打 log 都方便）
 
 函数替换为原始表达式也比变量替换更稳定
 
 缺点是补全有时候不好用，方括号的补全位置不对，剩下没有了吧
 
 关于命名
 ----
 所有快捷访问函数均以 App 开头
 
 一般 名字空间+限定+类型 的命名规则不同，这里按 名字空间+类型+限定 的方式命名
 */

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 应用配置/环境

@class DebugConfig;
FOUNDATION_EXPORT DebugConfig *AppDebugConfig();

@class MBEnvironment;
/// 状态依赖
MBEnvironment *AppEnv();

@class MBRootWrapperViewController;
/// 全局根视图
FOUNDATION_EXPORT MBRootWrapperViewController *_Nullable AppRootViewController();

@class ZYNavigationController;
/// 全局导航
ZYNavigationController *__nullable AppNavigationController();

/**
 尝试获取当前视图上的 item

 @param exceptClass 可选，非空将检查 item 类型，只在符合时才返回
 @return 当前视图上的 item，会尝试遍历一层子 vc
 */
id __nullable AppCurrentViewControllerItem(Class __nullable exceptClass);

@class MBWorkerQueue;
/// 全局 worker 队列
MBWorkerQueue *AppWorkerQueue();

/// 后台 worker 队列，注意后台的意思是 perform 是在后台线程执行的
MBWorkerQueue *AppBackgroundWorkerQueue();

#pragma mark - 用户信息

@class MBUser;
/// 当前登录的用户，可以用来判断是否已登录
MBUser *__nullable AppUser();

/// 当前用户的 ID
FOUNDATION_EXPORT long AppUserID();

/// 总是非空
FOUNDATION_EXPORT NSNumber *AppUserIDNumber();

@class UserInformation;
UserInformation *_Nullable AppUserInformation();

@class APIUserPlugin;
APIUserPlugin *AppUserManager();

#pragma mark - 存储

/// 应用级别的配置项
FOUNDATION_EXPORT NSUserDefaults *AppUserDefaultsShared();

@class MBUserProfiles;
/// 当前用户的配置项
FOUNDATION_EXPORT MBUserProfiles *_Nullable AppUserDefaultsPrivate();

@class RLMRealm;
/// 应用数据库
FOUNDATION_EXPORT RLMRealm *AppStorageShared();

/// 用户专用数据库，只在登录后有效
/// @warning 多次调用可能返回不同的非空对象，建议同一个上下文存储到一个临时变量里访问
FOUNDATION_EXPORT RLMRealm *_Nullable AppStoragePrivate();


#pragma mark - 特殊标记

/// 应用已进入前台，但不包括应用启动和前后台切换过程中
FOUNDATION_EXPORT BOOL AppActive();

/// 应用处于后台
FOUNDATION_EXPORT BOOL AppInBackground();

/**
 分享域名
 
 @code
 AppShareDomain(nil);      // @"http://share.feelapp.cc"
 AppShareDomain(@"/a/");   // @"http://share.feelapp.cc/a/"
 @endcode

 @param path 可选拼接的路径，注意参数时直接拼到最后的，没有做检查
 @return 分享域名或拼接后的分析地址
 */
NSString *__nonnull AppShareDomain(NSString *__nullable path);

NS_ASSUME_NONNULL_END
