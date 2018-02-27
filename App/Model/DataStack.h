/*!
    DataStack
    v 1.0

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "Common.h"
#import <Realm/Realm.h>
#import "MBModel.h"
#import "Realm+ZYHelper.h"

/**
 >= 0 表示上传重试次数
 -1   表示已经上传了
 -2   已删除
 -3   损坏的数据
 */
typedef NS_ENUM(int, MBDataSyncFlag) {
    MBDataSyncFlagBadData = -3,
    MBDataSyncFlagDeleted = -2,
    MBDataSyncFlagDone    = -1,
    MBDataSyncFlagWaiting = 0,
    MBDataSyncFlagReady   = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface MBDataStack : NSObject <
    RFInitializing
>

@property (nonatomic, readonly, strong) RLMRealm *sharedStorage;

- (NSURL *)realmDirURL;
- (RLMRealmConfiguration *)realmConfigurationWithPath:(NSURL *)path;
- (nullable RLMRealm *)realmWithURL:(nonnull NSURL *)url;

+ (void)writeToSharedStorageWithBlock:(NS_NOESCAPE void (^)(RLMRealm *storage))block;

@end

typedef NS_ENUM(int, RLMObjectFetchingPolicy) {
    RLMObjectFetchingPolicyDefault = 0,

    // 只返回数据库中存在的实例
    RLMObjectFetchingPolicyOnlyExisted,

    // 不检查数据库中是否存在，强制创建
    RLMObjectFetchingPolicyForceCreate,
};

@interface RLMResults <RLMObjectType> (App)

- (RLMResults <RLMObjectType>*)objectsWithPredicateFormat:(NSString *)predicateFormat, ...;

@end

NS_ASSUME_NONNULL_END
