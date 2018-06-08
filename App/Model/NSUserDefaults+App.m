
#import "NSUserDefaults+App.h"
#import "MBApp.h"
#import <MBAppKit/MBModel.h>
#import <MBAppKit/MBUserDefaultsMakeProperty.h>

@implementation NSUserDefaults (App)

_makeObjectProperty(debugConfigJSON, setDebugConfigJSON);

_makeObjectProperty(applicationLastLaunchTime, setApplicationLastLaunchTime)
_makeObjectProperty(lastVersion, setLastVersion)
_makeObjectProperty(previousVersion, setPreviousVersion)

_makeIntegerProperty(launchCount, setLaunchCount)
_makeIntegerProperty(launchCountCurrentVersion, setLaunchCountCurrentVersion)
_makeObjectProperty(applicationLastBecomeActiveTime, setApplicationLastBecomeActiveTime)

_makeObjectProperty(cachedLocation, setCachedLocation);

#if MBUserStringUID
_makeObjectProperty(lastUserID, setLastUserID);
#else
_makeIntegerProperty(lastUserID, setLastUserID);
#endif
_makeObjectProperty(userAccount, setUserAccount);
_makeObjectProperty(APUserInfo, setAPUserInfo);
_makeObjectProperty(userToken, setUserToken);

_makeObjectProperty(lastNotificationRecived, setLastNotificationRecived);
_makeObjectProperty(lastNotificationRecivedTime, setLastNotificationRecivedTime);

@end

#pragma mark - 用户存储

@implementation NSAccountDefaults (App)

- (instancetype)initWithSuiteName:(NSString *)suitename {
    self = [super initWithSuiteName:suitename];
    if (![[MBApp status].version isEqualToString:self.lastVersion]) {
        [self updateFromVersion:self.lastVersion];
    }
    return self;
}

- (void)updateFromVersion:(NSString *)currentVersion {
    // 前面的版本写当前版本
//    if ([@"2.6.2" compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
//        [self removeObjectForKey:@"GoalHealthRecordForShare"];
//    }
    self.lastVersion = currentVersion;
    [self synchronize];
}

@end
