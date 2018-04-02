/*!
    MBApp

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "Common.h"
#import "API.h"
#import "MBEnvironment.h"
#import "debug.h"
#import "APUser.h"
#import "NSUserDefaults+App.h"
// 非核心模块不要 import，避免头文件的循环引用

@class APINetworkActivityManager;
@class MBDataStack;
@class MBNavigationController;

/**
 全局变量中心

 你应该避免使用全局变量，全局变量的存在十有七八都是不合适的。
 但适当的引入全局变量可以极大的简化各个模块，提高模块间的数据交换效率。

 如果你不得不用全局变量，把它加到这里吧。这个模块在所有文件中均可访问。
 */
@interface MBApp : NSObject

+ (nonnull instancetype)status;

#pragma mark - 应用配置

/**
 短版本号，形如 2.6.0
 */
@property (nonnull, readonly) NSString *version;

/**
 从哪个版本升上来的
 如果不是升级后的第一次启动为空
 */
@property (nullable, readonly) NSString *previousVersion;

/**
 判断一个版本是否是新的
 */
- (BOOL)isNewVersion:(NSString *_Nonnull)version;

/// init 时创建
@property (nonnull, readonly) DebugConfig *debugConfig;

#pragma mark - 挂载的 manager

/// 状态管理
@property (nonnull, readonly) MBEnvironment *env;

/// 应用接口管理，访问时懒加载，MBApp 初始化后自动创建
@property (nonnull, readonly) API *api;

/// 提示 UI 管理，访问时懒加载
@property (nonnull, readonly) APINetworkActivityManager *hud;

/// 全局导航
@property (nonatomic, nullable) MBNavigationController *globalNavigationController;

#pragma mark - Data Pool

/**
 访问时懒加载
 */
@property (nonatomic, null_resettable, strong) MBDataStack *dataStack;

@end
