/*!
    debug.h
    应用调试开关

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#pragma once

#import "Common.h"

/** `
 dout() 的行为可在 Build settings 的 Preprocessor Macros 项调节
 */

/**
 Stop on Debugger() for iOS

 函数内部不区分是否是 DEBUG 编译
 */
FOUNDATION_EXPORT void RFDebugger(NSString *_Nullable format, ...) NS_FORMAT_FUNCTION(1, 2);

/**
 弹出调试信息，只在 debug mode 时
 
 函数内部不区分是否是 DEBUG 编译
 */
FOUNDATION_EXPORT void DebugAlert(NSString *_Nonnull format, ...) NS_FORMAT_FUNCTION(1, 2);

/**
 综合性调试方法，会在不同环境做合适的处理
 
 @param fatal 如果是 YES，在调试时会在这个位置停住
 @param recordID 非空时，会在正式和内测环境记录 Fabric 错误
 */
FOUNDATION_EXPORT void DebugLog(BOOL fatal, NSString *_Nullable recordID, NSString *_Nonnull format, ...) NS_FORMAT_FUNCTION(3, 4);


/**
 展示一个错误弹窗给用户，正常不会遇到但是还要给用户一个交待时使用

 @param recordID 非空时，会在正式和内测环境记录 Fabric 错误
 */
FOUNDATION_EXPORT void RFErrorAlert(NSString *_Nullable recordID, NSString *_Nonnull format, ...) NS_FORMAT_FUNCTION(2, 3);

/**
 断言 obj 是 aClass
 
 @return obj 为空或时 aClass 返回 YES，类型不匹配返回 NO
 */
FOUNDATION_EXPORT BOOL RFAssertKindOfClass(id __nullable obj, Class __nonnull aClass);

/**
 断言在主线程
 
 @return YES 在主线程，NO 不在主线程
 */
FOUNDATION_EXPORT BOOL RFAssertIsMainThread(void);

/**
 断言在不主线程

 @return YES 不在主线程，NO 在主线程
 */
FOUNDATION_EXPORT BOOL RFAssertNotMainThread(void);

FOUNDATION_EXPORT unsigned long long MBApplicationMemoryUsed(void);
FOUNDATION_EXPORT unsigned long long MBApplicationMemoryAll(void);

#pragma mark - 网络调试

/// 如果你想模拟网络延迟，可以使用 Network Link Conditioner
/// 像 Charles 等代理软件也支持限速模拟

/// 每次启动强制自动更新，忽略更新间隔检查
#define DebugAPIUpdateForceAutoUpdate 0

#pragma mark - 其他



#pragma mark - DebugConfig

extern BOOL DebugFlagForceLoadLocalAppConfig;

#import "MBModel.h"

@class APUserInfo;

@interface DebugConfig : MBModel

/// 快速进入
@property (nonatomic) BOOL fastMenu;

/// 禁用通知轮训检查
@property (nonatomic) BOOL disableNotificationPolling;

/// 使用本地分享模版
@property (nonatomic) BOOL localShareTemplate;

/// 从服务器获取应用配置时警告
@property (nonatomic) BOOL alertWhenAppConfigUpdate;

#pragma mark 推送

/// 收到通知时提示
@property (nonatomic) BOOL alertNotification;

/// 模拟的推送
@property (nonatomic, nullable, strong) NSDictionary *simulatedNotification;

/// 模拟的推送在启动时执行
@property (nonatomic) BOOL simulateNotificationWhenLaunch;

#pragma mark 模拟位置
@property (nonatomic) BOOL simulateCoordinate;
@property (nonatomic) double simulatedCoordinateLatitude;
@property (nonatomic) double simulatedCoordinateLongitude;
@property (nonatomic, nullable, strong) NSString *simulatedCoordinateTitle;

#pragma mark 用户

/// 不自动登录私聊
@property (nonatomic) BOOL disableChatAutoLogin;

@property (nonatomic, nullable, copy) APUserInfo *productionUserInformation;
@property (nonatomic, nullable, copy) NSString *productionToken;
@property (nonatomic, nullable, copy) APUserInfo *developUserInformation;
@property (nonatomic, nullable, copy) NSString *developToken;
@property (nonatomic) BOOL bindUserInfoToServer;

@property (nonatomic) BOOL forceSelectStyleAfterLogin;

#pragma mark 工具

/// 计步器数据获取回调延迟
@property (nonatomic) BOOL pedometerCallbackDelay;

/// 小米手环返回模拟数据
@property (nonatomic) BOOL simulateMiBandData;

#pragma mark Debug

/// 测试服务器
@property (nonatomic) BOOL debugServer;

/// 正式数据的测试服务器
@property (nonatomic) BOOL alphaServer;

/// 正式服务器
@property (nonatomic, readonly) BOOL productServer;

/// 允许 SSL 嗅探
@property (nonatomic) BOOL allowSSLDebug;

/// 调试模式
@property (nonatomic) BOOL debugMode;

/// 启动时激活 flex
@property (nonatomic) BOOL showFlexWhenLaunch;

/// 禁用在开发版本提示切换到生产环境
@property (nonatomic) BOOL disableNoticeSwithToDebugServer;

/// 后台统计请求提示
@property (nonatomic) BOOL alertDataReport;

/// 后台运行状态提示
@property (nonatomic) BOOL alertBackgroundRunning;

- (void)synchronize;

@end
