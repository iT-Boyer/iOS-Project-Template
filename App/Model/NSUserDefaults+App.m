
#import "NSUserDefaults+App.h"
#import "MBApp.h"
#import "MBGeneralSetNeedsDoSomthing.h"
#import "MBModel.h"
@import ObjectiveC;


@implementation NSUserDefaults (Sync)
MBSynthesizeSetNeedsMethodUsingAssociatedObject(setNeedsSynchronized, synchronize, 0.1)

- (BOOL)synchronizeBlock:(NS_NOESCAPE void (^_Nonnull)(NSUserDefaults *_Nonnull u))block {
    if (!block) return YES;
    block(self);
    return [self synchronize];
}

@end


@implementation NSUserDefaults (App)

// 默认的 NSUserDefaults 会自动同步，而我们建的用户 MBUserProfiles 不会自动同步
#define ClassSynchronize \
    if ([self isMemberOfClass:[MBUserProfiles class]]) {\
        [self setNeedsSynchronized];\
    }

#define _makeBoolProperty(NAME, SETTER, UDKey) \
    @dynamic NAME;\
    - (BOOL)NAME {\
        return [self boolForKey:UDKey];\
    }\
    - (void)SETTER:(BOOL)NAME {\
        [self setBool:NAME forKey:UDKey];\
        ClassSynchronize\
    }

#define _makeIntegerProperty(NAME, SETTER, UDKey) \
    @dynamic NAME;\
    - (NSInteger)NAME {\
        return [self integerForKey:UDKey];\
    }\
    - (void)SETTER:(NSInteger)NAME {\
        [self setInteger:NAME forKey:UDKey];\
        ClassSynchronize\
    }

#define _makeObjectProperty(NAME, SETTER, UDKey) \
    @dynamic NAME;\
    - (id)NAME {\
        return [self objectForKey:UDKey];\
    }\
    - (void)SETTER:(id)NAME {\
        [self setObject:NAME forKey:UDKey];\
        ClassSynchronize\
    }

#define _makeURLProperty(NAME, SETTER, UDKey) \
    @dynamic NAME;\
    - (id)NAME {\
        return [self URLForKey:UDKey];\
    }\
    - (void)SETTER:(id)NAME {\
        [self setURL:NAME forKey:UDKey];\
        ClassSynchronize\
    }

#define _makeModelProperty(UDKey, NAME, IVAR, SETTER, MODEL_CLASS) \
    @synthesize NAME = IVAR;\
    - (MODEL_CLASS *)NAME {\
        if (IVAR) return IVAR;\
        NSString *json = [self objectForKey:@UDKey];\
        if (json) {\
            IVAR = [[MODEL_CLASS alloc] initWithString:json error:nil];\
        }\
        return IVAR;\
    }\
    - (void)SETTER:(MODEL_CLASS *)NAME {\
        IVAR = NAME;\
        NSString *json = [NAME toJSONString];\
        [self setObject:json forKey:@UDKey];\
        ClassSynchronize\
    }

#define _makeModelArrayProperty(UDKey, NAME, SETTER, MODEL_CLASS) \
    @dynamic NAME;\
    - (NSArray<MODEL_CLASS *> *)NAME {\
        NSArray *json = [self objectForKey:@UDKey];\
        return [MODEL_CLASS arrayOfModelsFromDictionaries:json error:nil];\
    }\
    - (void)SETTER:(NSArray<MODEL_CLASS *> *)NAME {\
        NSArray *json = [MODEL_CLASS arrayOfDictionariesFromModels:NAME];\
        [self setObject:json forKey:@UDKey];\
        ClassSynchronize\
    }

#define _makeCachedModelArrayProperty(UDKey, NAME, IVAR, SETTER, MODEL_CLASS) \
    @synthesize NAME = IVAR;\
    - (NSArray<MODEL_CLASS *> *)NAME {\
        if (IVAR) return IVAR;\
        NSArray *json = [self objectForKey:@UDKey];\
        IVAR = [MODEL_CLASS arrayOfModelsFromDictionaries:json error:nil];\
        return IVAR;\
    }\
    - (void)SETTER:(NSArray<MODEL_CLASS *> *)NAME {\
        IVAR = NAME;\
        NSArray *json = [MODEL_CLASS arrayOfDictionariesFromModels:NAME];\
        [self setObject:json forKey:@UDKey];\
        ClassSynchronize\
    }

#pragma mark -

_makeObjectProperty(debugConfigJSON, setDebugConfigJSON, @"debug.config");

_makeBoolProperty(launchGuard, setLaunchGuard, @"core.LaunchGuard")
_makeObjectProperty(applicationLastLaunchTime, setApplicationLastLaunchTime, @"core.LaunchTime")
_makeObjectProperty(lastVersion, setLastVersion, @"core.app_version")
_makeObjectProperty(previousVersion, setPreviousVersion, @"core.app_version_last")

_makeIntegerProperty(launchCount, setLaunchCount, @"core.LaunchCount")
_makeIntegerProperty(launchCountCurrentVersion, setLaunchCountCurrentVersion, @"core.LaunchCountVersion")
_makeObjectProperty(applicationLastBecomeActiveTime, setApplicationLastBecomeActiveTime, @"core.AppActiveTime")

_makeObjectProperty(cachedLocation, setCachedLocation, @"Last Location");

_makeIntegerProperty(lastUserID, setLastUserID, @"user.ID");
_makeObjectProperty(userAccount, setUserAccount, @"user.account");
_makeObjectProperty(APUserInfo, setUserInformation, @"user.information");
_makeObjectProperty(userToken, setUserToken, @"user.token");

_makeObjectProperty(lastNotificationRecived, setLastNotificationRecived, @"notification.lastInfo");
_makeObjectProperty(lastNotificationRecivedTime, setLastNotificationRecivedTime, @"notification.lastTime");

@end

#pragma mark - 用户存储

@implementation MBUserProfiles

- (instancetype)initWithSuiteName:(NSString *)suitename {
    self = [super initWithSuiteName:suitename];
    if (![[MBApp status].version isEqualToString:self.lastVersion]) {
        [self updateFromVersion:self.lastVersion];
    }
    return self;
}

- (BOOL)synchronizeBlock:(void (^)(MBUserProfiles *))block {
    return [super synchronizeBlock:(id)block];
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
