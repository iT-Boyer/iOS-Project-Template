
#import "JPushManager.h"
#import "MBApplicationDelegate.h"
#import "UIDevice+ZYIdentifier.h"
#import "debug.h"
#import <JPush/JPUSHService.h>
@import ObjectiveC;
@import UserNotifications;
// 这个类不应该跟应用业务扯上任何关系

BOOL MBDebugConfigPushDebugLogEnabled = NO;


@interface JPushManager () <
    UNUserNotificationCenterDelegate>
{
    BOOL _initWithConfiguration;
}
@property (nonatomic, strong, readwrite) NSMutableSet *pushTags;

/// 超时重设次数
@property (nonatomic) int aliasAndTagSyncRetryLimite;
@end


@implementation JPushManager
RFInitializingRootForNSObject;

+ (nonnull instancetype)managerWithConfiguration : (void (^_Nonnull)(JPushManager *_Nonnull manager))configBlock
{
    NSParameterAssert(configBlock);
    JPushManager *this = [self new];
    configBlock(this);
    this->_initWithConfiguration = YES;

    NSAssert(this.appKey, @"JPush app key 必需设置");
    [JPUSHService setupWithOption:this.launchOptions appKey:this.appKey channel:nil apsForProduction:this.apsForProduction advertisingIdentifier:[UIDevice ZYIdentifierForAdvertising]];
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = this;
    }
    return this;
}

- (void)onInit
{
    self.resetBadgeAfterLaunching = YES;
    self.aliasAndTagSyncRetryLimite = 2;

    if (MBDebugConfigPushDebugLogEnabled) {
#ifndef DEBUG
        NSAssert(false, @"非开发模式需关闭日志");
#endif
        [JPUSHService setDebugMode];
    } else {
        [JPUSHService setLogOFF];
    }
    self.pushTags = [NSMutableSet setWithCapacity:20];
}

- (void)afterInit
{
    douto([UNUserNotificationCenter currentNotificationCenter].delegate)
        RFAssert(_initWithConfiguration, @"You must create JPushManager with managerWithConfiguration: method.");
    if (MBDebugConfigPushDebugLogEnabled) {
        dout_debug(@"JPushManager 启动检查");
    }
    if (self.resetBadgeAfterLaunching) {
        // 在前台且未设置进入前台时自动清零才在这里清零
        if (AppActive() && !self.resetBadgeWhenApplicationBecomeActive) {
            [self resetBadge];
        }
    }

    [AppDelegate() addAppEventListener:self];
    [self registerForRemoteNotificationsIfNeeded];

    NSDictionary *lq = self.launchOptions;
    if (lq) {
        self.launchOptions = nil;
        if (NSClassFromString(@"UNUserNotificationCenter")) {
            // iOS 10 走到这里 UNUserNotificationCenter 已经接收了
            return;
        }
        UILocalNotification *ln = lq[UIApplicationLaunchOptionsLocalNotificationKey];
        if (ln) {
            [self handleLocalNotification:ln fromLaunch:YES];
        }
        NSDictionary *dic = lq[UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dic) {
            [self handleRemoteNotification:dic fromLaunch:YES];
        }
    }
}

- (void)dealloc
{
    self.resetBadgeWhenApplicationBecomeActive = NO;
}

- (void)registerForRemoteNotificationsIfNeeded
{
    UIApplication *ap = [UIApplication sharedApplication];
    if ([ap respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [ap registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [ap registerUserNotificationSettings:settings];
    } else {
        // iOS 7
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
            UIRemoteNotificationTypeSound |
            UIRemoteNotificationTypeAlert;
        [ap registerForRemoteNotificationTypes:notificationTypes];
    }
}


MBSynthesizeSetNeedsDelayMethodUsingAssociatedObject(setNeedsSyncAliasAndTag, doSetAliasAndTag, 0.1);

- (void)doSetAliasAndTag
{
    if (self.aliasAndTagSyncRetryLimite <= 0) {
        DebugLog(NO, nil, @"已达到推送标签设置重试上限");
        return;
    }

    NSMutableSet *fullTags = [self.pushTags mutableCopy];
    NSSet *ft = [JPUSHService filterValidTags:fullTags];
#if DEBUG
    if (ft) {
        // 去掉过滤后的标签多出的，就是不合法的标签
        // 模拟器过滤标签总是 nil，忽略
        [fullTags minusSet:ft];
        NSAssert(!fullTags.count, @"不合法的推送标签: %@", fullTags);
    }
#endif

    if (!ft.count && !self.pushAlias) {
        // 没有必要的设置，我们的业务上也不会出现均为空的情况
        if (MBDebugConfigPushDebugLogEnabled) {
            dout_debug(@"没有 push alias/tag 需要设置");
        }
        return;
    }

    [JPUSHService setTags:ft alias:self.pushAlias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        // should retain self
        if (iResCode == 0) {
            // 成功
            if (MBDebugConfigPushDebugLogEnabled) {
                dout_debug(@"设置 push alias/tag 成功, %@, %@", iAlias, iTags);
            }
        } else {
            // 失败，具体错误码见： http://docs.jpush.io/client/ios_api/#_21
            if (MBDebugConfigPushDebugLogEnabled) {
                dout_debug(@"设置 push alias/tag 失败, %@, %@", iAlias, iTags);
            }
            self.aliasAndTagSyncRetryLimite--;
            if (iResCode == 6002) {
                // 超时重试
                [self setNeedsSyncAliasAndTag];
            }
        }
    }];
}

+ (nonnull NSString *)stringFromDeviceToken:(nonnull NSData *)deviceToken
{
    const char *data = deviceToken.bytes;
    NSMutableString *token = [NSMutableString string];

    for (int i = 0; i < deviceToken.length; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    return token;
}

#pragma mark -

/**
 应用未启动，点击通知启动应用，launchOptions 和 didReceiveRemoteNotification 都会有这条推送的信息
 当应用切到后台，或从后台启动，didReceiveRemoteNotification 调用，此时 AppActive() 是 NO
 如果应用在前台，收到通知，didReceiveRemoteNotification 调用，此时 AppActive() 是 YES
 */
- (void)handleRemoteNotification:(NSDictionary *)notification fromLaunch:(BOOL)fromLaunch
{
    dout_info(@"收到推送信息：%@", notification);
    RFAssert(notification, @"不应为空");
    if (!notification) return;
    [JPUSHService handleRemoteNotification:notification];
    if ([self.lastNotificationReceived isEqual:notification] && ![notification valueForKeyPath:@"aps.content-available"]) {
        // 通过 content-available 启动，会调两次，afterInit 只当用户打开时才会调用
        // 普通点推送即使有 launchOptions，因为应用事件是后注册的，这里只会收到一次
        RFAssert(false, @"目前期望不会有重复的推送");
        return;
    }

    // 这里不考虑 content-available 的影响了，正常期望让用户点击的推送不应该带 content-available，带 content-available 的不应该带标题让用户可点
    // 现在我们有两个状态量 fromLaunch（是不是首次启动），AppActive()（启动时是前台还是后台）
    // 分成四种情况：Y Y，用户点击推送启动；Y N，后台 content-available 唤醒启动；
    // N Y，应用在前台；N N，应用之前启动了，但现在处于后台，此时用户点击推送启动。
    BOOL isActive = AppActive();
    BOOL byUserClick = (fromLaunch && isActive) || (!fromLaunch && !isActive);
    if (self.receiveRemoteNotificationHandler) {
        self.receiveRemoteNotificationHandler(notification, nil, byUserClick);
    }
    self.lastNotificationReceived = notification;
}

- (void)handleLocalNotification:(UILocalNotification *)notification fromLaunch:(BOOL)fromLaunch
{
    dout_info(@"收到本地推送信息：%@", notification);
    RFAssert(notification, @"不应为空");
    if (!notification) return;
    RFAssert(![self.lastNotificationReceived isEqual:notification], @"目前期望不会有重复的推送");

    BOOL isActive = AppActive();
    BOOL byUserClick = (fromLaunch && isActive) || (!fromLaunch && !isActive);
    if (self.receiveLocalNotificationHandler) {
        self.receiveLocalNotificationHandler(notification.userInfo, notification, byUserClick);
    }
    self.lastNotificationReceived = notification.userInfo;
}

// The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        if (self.receiveRemoteNotificationHandler) {
            self.receiveRemoteNotificationHandler(userInfo, response.notification, YES);
        }
        self.lastNotificationReceived = userInfo;
    } else {
        if (self.receiveLocalNotificationHandler) {
            self.receiveLocalNotificationHandler(userInfo, response.notification, YES);
        }
        self.lastNotificationReceived = userInfo;
    }
    completionHandler();
}

#pragma mark - Application 事件响应

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *tokenString = [self.class stringFromDeviceToken:deviceToken];
    self.deviceToken = tokenString;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleRemoteNotification:userInfo fromLaunch:NO];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self handleLocalNotification:notification fromLaunch:NO];
}

#pragma mark - 角标管理

- (void)setResetBadgeWhenApplicationBecomeActive:(BOOL)resetBadgeWhenApplicationBecomeActive
{
    if (_resetBadgeWhenApplicationBecomeActive != resetBadgeWhenApplicationBecomeActive) {
        if (_resetBadgeWhenApplicationBecomeActive) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        }
        _resetBadgeWhenApplicationBecomeActive = resetBadgeWhenApplicationBecomeActive;
        if (resetBadgeWhenApplicationBecomeActive) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActiveThenResetBadge) name:UIApplicationDidBecomeActiveNotification object:nil];
        }
    }
}

- (void)onApplicationBecomeActiveThenResetBadge
{
    // 保持两秒在前台才去清零
    dispatch_after_seconds(2, ^{
        if (AppActive()) {
            [self resetBadge];
        }
    });
}

- (void)resetBadge
{
    if (MBDebugConfigPushDebugLogEnabled) {
        dout_debug(@"应用通知气泡清零");
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

@end
