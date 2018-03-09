/*!
    JPushManager
    v 5.0

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

/**
 极光推送封装，需要至少 2.1

 使用：
 1. managerWithConfiguration: 初始化实例
 2. 创建后会自行注册到 MBApplicationDelegate 上，不需要在其他文件中写任何代码
 3. 设置 receiveRemoteNotificationHandler, receiveLocalNotificationHandler 响应通知
 
 这个类是按原样使用设计的，既不应该重写，也不应该拿来修改。
 */
@interface JPushManager : NSObject <UIApplicationDelegate, RFInitializing>

#pragma mark - 初始状态配置

/**
 如果配置不符合要求会抛出 NSInternalInconsistencyException 异常

 @param configBlock 不能为空，在这个 block 里进行设置
 */
+ (nonnull instancetype)managerWithConfiguration:(void (^_Nonnull)(JPushManager *_Nonnull manager))configBlock;

/// JPush 的 app key
@property (nonatomic, nonnull, strong) NSString *appKey;

/// 服务器端推送使用生产证书还是测试证书
@property (nonatomic) BOOL apsForProduction;

/// 应用启动时的 launchOptions
/// manager 创建后会被清空
@property (nonatomic, nullable, strong) NSDictionary *launchOptions;

#pragma mark - 启动流程

/// 处理收到的通知
/// notification 可能是 UNNotification
@property (nonatomic, nullable, copy) void (^receiveRemoteNotificationHandler)(NSDictionary *__nonnull info, id __nullable notification, BOOL userClick);

/// 处理收到的本地通知
/// notification 可能是 UILocalNotification 或 UNNotification
@property (nonatomic, nullable, copy) void (^receiveLocalNotificationHandler)(NSDictionary *__nonnull info, id __nullable notification, BOOL userClick);

/**
 最后收到的推送，可以用于判断通知收到的时机
 
 如果最近一条是本地通知，内容是通知对象的 userInfo
 */
@property (nonatomic, nullable, strong) NSDictionary *lastNotificationReceived;

#pragma mark - Alias Tag

/// @"" 取消设置， nil 不设置
@property (nonatomic, nullable, copy) NSString *pushAlias;

/// 空集合取消设置，nil 不设置
@property (nonatomic, nonnull, readonly) NSMutableSet *pushTags;

/// 需要手动调用以同步 Alias Tag 设置
- (void)setNeedsSyncAliasAndTag;

@property (nonatomic, nullable, copy) NSString *deviceToken;
+ (nonnull NSString *)stringFromDeviceToken:(nonnull NSData *)deviceToken;

#pragma mark - 角标管理

/**
 应用启动后重置角标，需要实例创建后立即设置
 
 默认 YES
 */
@property (nonatomic) BOOL resetBadgeAfterLaunching;

/**
 应用进入前台后重置角标
 
 默认 NO
 */
@property (nonatomic) BOOL resetBadgeWhenApplicationBecomeActive;

/**
 清空本地应用和极光服务器上的 badge
 */
- (void)resetBadge;

@end

/// 设为 YES 已启用额外的调试日志
extern BOOL MBDebugConfigPushDebugLogEnabled;
/// JPush 自定义消息通知
extern NSString *__nonnull const kJPFNetworkDidReceiveMessageNotification;
