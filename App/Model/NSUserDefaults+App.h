//
//  UserDefaults 字段定义
//  App
//

#import <MBAppKit/MBGeneralType.h>
#import <MBAppKit/MBUserDefaults.h>

@class AccountEntity;

/**
 迁移到 Swift 版本动力不足，没有让定义与使用变得更轻松：
 key 多需要额外定义，用时也多需额外声明，不方便。
 */
@interface NSUserDefaults (App)

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

#pragma mark - User Information

#if MBUserStringUID
@property (nullable) MBIdentifier lastUserID;
#else
@property int64_t lastUserID;
#endif

@property (nullable, copy) AccountEntity *accountEntity;
@property (nullable, copy) NSString *userToken;

@end

#pragma mark - 用户存储

@interface NSAccountDefaults (App)

@end
