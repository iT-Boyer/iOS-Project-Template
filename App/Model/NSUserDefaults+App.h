//
//  NSUserDefaults+App.h
//  Feel
//
//  Created by BB9z on 3/25/15.
//  Copyright (c) 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface NSUserDefaults (Sync)

- (void)setNeedsSynchronized;

/**
 */
- (BOOL)synchronizeBlock:(NS_NOESCAPE void (^_Nonnull)(NSUserDefaults *_Nonnull u))block;

@end

/**
 关于属性声明
 
 NSUserDefaults 原生支持的类型，可以用 _makeXXXProperty 实现属性，属性声明应用 (nullable, copy) 修饰。
 _makeModelProperty 和 _makeModelArrayProperty 用于生成 JSONModel 对象，默认会缓存结果，需要用 (nonatomic, nullable, strong) 修饰。
 
 @warning _makeModelProperty 和 _makeModelArrayProperty 生成的结果不是 copy 的，意味着如果你修改 model，其他地方访问到的结果也会跟着变。但是 NSUserDefaults 的存储不会变
 
 自己写的 selector 其属性声明要看具体是如何实现的，NSUserDefaults 是线程安全的，如果实现中有非原子操作则需要标明是 nonatomic 的，nullability 正常看实现标。
 */
@interface NSUserDefaults (App)

@property (nullable, copy) NSString *debugConfigJSON;

#pragma mark -

@property BOOL launchGuard;

/// 上次启动时间
@property (nullable, copy) NSDate *applicationLastLaunchTime;

/// 上次启动时版本
@property (nullable, copy) NSString *lastVersion;

/// 上次更新版本时的版本
@property (nullable, copy) NSString *previousVersion;

/// App 总启动次数
@property NSInteger launchCount;

/// 当前版本启动次数
@property NSInteger launchCountCurrentVersion;

/// 上次应用进入前台的时间
@property (nullable, copy) NSDate *applicationLastBecomeActiveTime;

#pragma mark - App Config

/// 缓存的用户地理位置
@property (nullable, copy) NSDictionary *cachedLocation;

#pragma mark - User Information

@property long lastUserID;

@property (nullable, copy) NSString *userAccount;
@property (nullable, copy) NSString *APUserInfo;
@property (nullable, copy) NSString *userToken;

#pragma mark - 通知

@property (nullable, copy) NSDictionary *lastNotificationRecived;
@property (nullable, copy) NSDate *lastNotificationRecivedTime;

@end

#pragma mark - 用户存储

/**
 @warning standardUserDefaults 会自动同步，而这个不会。
 如果属性的实现用的是 _makeXXXProperty，同步操作已经有了妥当处理。
 为了统一，自定义实现的方法需要在设置时调用 setNeedsSynchronized。
 */
@interface MBUserProfiles : NSUserDefaults

- (BOOL)synchronizeBlock:(void (^_Nonnull)(MBUserProfiles *_Nonnull u))block;

@end
