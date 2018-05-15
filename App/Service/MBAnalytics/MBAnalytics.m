
#import "MBAnalytics.h"
#import "CommonUI.h"
#import "MBApp.h"
#import "UIDevice+RFKit.h"
#import "debug.h"
#import "RFSynthesizeCategoryProperty.h"

void MBCLog(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
}

#ifndef DEMO
#define MobClickEnabled 0
#endif

#if MobClickEnabled
static BOOL MBAnalyticsIsMobClickInitialized;
#endif

MBAnalyticsEvent *MBAnalyticsCurrentPageEvent;
NSString *const MBAnalyticsExitPageName = @"EXIT";

@interface MBAnalyticsEvent ()
@property (assign, readwrite) CFTimeInterval startTime;
@end


@interface MBAnalytics () <
    UIApplicationDelegate
>
@property (nonatomic, strong) NSNumber *remoteNotificationAuthorizationStatus;
@property BOOL hasStartFabric;
@property NSMutableArray<NSDictionary *> *feelEventQuene;
@property BOOL sendingFeelEvent;
@end

@implementation MBAnalytics

+ (MBAnalytics *)_privateInstance {
    static MBAnalytics *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [MBAnalytics new];
        [AppDelegate() addAppEventListener:sharedInstance];
    }
    return sharedInstance;
}

+ (void)setup {
#if MobClickEnabled
    if (!MBAnalyticsIsMobClickInitialized) {
        [MobClick setCrashReportEnabled:NO];
        [MobClick setAppVersion:[MBApp status].version];
#if DEBUG
        [MobClick setLogEnabled:UIDevice.currentDevice.isBeingDebugged];
#endif
        [MobClick startWithConfigure:({
            UMAnalyticsConfig *cf = UMConfigInstance;
#if DEBUG
            cf.appKey = @"57de7f4267e58e7ca6001e1e";
#else
            cf.appKey = @"53faa119fd98c585b206fbff";
#endif
            cf.bCrashReportEnabled = NO;
            cf.ePolicy = SEND_INTERVAL;
            UMConfigInstance;
        })];
        [MobClick event:@"TI_Launch" label:AppInBackground()? @"后台" : @"前台"];
        MBAnalyticsIsMobClickInitialized = YES;
    }
#endif
}

/*
+ (void)startFabric {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MBAnalytics *pi = [self _privateInstance];
        if (pi.hasStartFabric) return;

        [Fabric with:@[CrashlyticsKit]];
        pi.hasStartFabric = YES;
#ifndef DEMO
        NSUserDefaults *ud = AppUserDefaultsShared();
        Crashlytics *cy = [Crashlytics sharedInstance];
        [cy setIntValue:(int)ud.launchCountCurrentVersion forKey:@"版本启动次数"];
        [cy setIntValue:(int)ud.launchCount forKey:@"总启动次数"];
        [cy setObjectValue:ud.applicationLastLaunchTime forKey:@"启动时间"];
        [cy setObjectValue:AppDelegate().applicationLastLaunchTime forKey:@"上次启动时间"];
        [cy setUserIdentifier:[AppUserIDNumber() stringValue]];
#endif
    });
}
 */

#pragma mark Event

- (void)addFeelEvent:(NSDictionary *)event {
    if (!self.feelEventQuene) {
        self.feelEventQuene = [NSMutableArray array];
    }
    [self.feelEventQuene rf_addObject:event];
    [self progressFeelEventIfNeeded];
}

- (void)progressFeelEventIfNeeded {
    if (self.sendingFeelEvent) return;
    NSDictionary *p = [self.feelEventQuene lastObject];
    if (!p) return;
    [self.feelEventQuene removeLastObject];

    self.sendingFeelEvent = YES;
    [API backgroundRequestWithName:AppDebugConfig().productServer? @"Analytic" : @"AnalyticDev" parameters:p completion:^(BOOL success, id responseObject, NSError *error) {
        self.sendingFeelEvent = NO;
        [self progressFeelEventIfNeeded];
    }];
}

+ (void)logEventWithName:(NSString *)eventName attributes:(nullable NSDictionary<NSString *, id> *)attributes {
    id abs = [self processedEventAttributes:attributes];
    dout_debug(@"Event %@ (%@)", eventName, attributes);
// @TODO
//    [Answers logCustomEventWithName:eventName customAttributes:abs];
}

+ (void)logLoginWithMethod:(nullable NSString *)loginMethod success:(nullable NSNumber *)isSucceeded attributes:(nullable NSDictionary<NSString *, id> *)attributes {
// @TODO
//    [Answers logLoginWithMethod:loginMethod success:isSucceeded customAttributes:[self processedEventAttributes:attributes]];
}

+ (void)logError:(nullable NSError *)error withName:(NSString *)eventName attributes:(nullable NSDictionary<NSString *,id> *)attributes {
    if (error) {
        if (![error respondsToSelector:@selector(code)] || ![error respondsToSelector:@selector(localizedDescription)]) {
            return;
        }
    }

    NSMutableDictionary *ab = [self processedEventAttributes:attributes];
    NSString *errorInfo = error? [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription] : @"?";
    dout_debug(@"%@ Error: %@", eventName, error);
    [ab rf_setObject:errorInfo forKey:@"Error"];
// @TODO
//    [Answers logCustomEventWithName:eventName customAttributes:ab];
}

+ (void)recordError:(NSError *)error withAttributes:(NSDictionary<NSString *,id> *)attributes {
// @TODO
//    [self startFabric];
    NSMutableDictionary *ab = [self processedEventAttributes:attributes];
//    [[Crashlytics sharedInstance] recordError:error withAdditionalUserInfo:ab];
}

+ (void)logRating:(nullable NSNumber *)ratingOrNil contentName:(nullable NSString *)contentNameOrNil contentType:(nullable NSString *)contentTypeOrNil contentID:(nullable id)contentID customAttributes:(nullable NSDictionary<NSString *, id> *)customAttributesOrNil {
    if ([contentID isKindOfClass:[NSNumber class]]) {
        contentID = [contentID stringValue];
    }
// @TODO
//    [Answers logRating:ratingOrNil contentName:contentNameOrNil contentType:contentTypeOrNil contentId:contentID customAttributes:[self processedEventAttributes:customAttributesOrNil]];
}

#pragma mark - 配对事件

+ (MBAnalyticsEvent *)startEvent:(NSString *)eventID {
    MBAnalyticsEvent *item = [MBAnalyticsEvent new];
    item.eventID = eventID;
    item.startTime = CFAbsoluteTimeGetCurrent();
    return item;
}

+ (void)endEvent:(MBAnalyticsEvent *)event {
    if (!event.eventID) return;

    NSTimeInterval duration = event.duration?: CFAbsoluteTimeGetCurrent() - event.startTime;
    NSMutableDictionary *info = [self processedEventAttributes:event.attributes];
    info[@"duration"] = @(duration);
// @TODO
    // [Answers logCustomEventWithName:event.eventID customAttributes:info];
}

+ (void)beginLogPageWithName:(NSString *)pageName {
#if MobClickEnabled
    if (![pageName isEqualToString:MBAnalyticsExitPageName]) {
        if (MBAnalyticsIsMobClickInitialized) {
            [MobClick beginLogPageView:pageName];
        }
    }
#endif
    if (MBAnalyticsCurrentPageEvent) {
        dout_warning(@"已经有页面 %@ 在记录了", MBAnalyticsCurrentPageEvent);
    }
    NSString *pageID = [NSString stringWithFormat:@"PG_%@", pageName];
    MBAnalyticsCurrentPageEvent = [self startEvent:pageID];
}

+ (void)endLogPageWithName:(NSString *)pageName attributes:(nullable NSDictionary<NSString *, id> *)attributes {
#if MobClickEnabled
    if (![pageName isEqualToString:MBAnalyticsExitPageName]) {
        if (MBAnalyticsIsMobClickInitialized) {
            [MobClick endLogPageView:pageName];
        }
    }
#endif
    NSString *pageID = [NSString stringWithFormat:@"PG_%@", pageName];
    if (![pageID isEqualToString:MBAnalyticsCurrentPageEvent.eventID]) {
        dout_warning(@"结束页面不匹配");
    }
    MBAnalyticsCurrentPageEvent.attributes = attributes;
    [self endEvent:MBAnalyticsCurrentPageEvent];
    MBAnalyticsCurrentPageEvent = nil;
}

#pragma mark - Tool

/// 处理事件参数字典，将其中可能的键值转化为可以接受的
+ (NSMutableDictionary<NSString *, id> *)processedEventAttributes:(nullable NSDictionary<NSString *, id> *)attributes {
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:attributes.count];
    for (NSString *key in attributes) {
        id value = attributes[key];
        if ([value isKindOfClass:[NSNumber class]]) {
#if DEBUG
            const char *rawType = [value objCType];
            if (strcmp(rawType, "c") == 0) {
                DebugLog(YES, nil, @"事件参数不支持 BOOL, key = %@", key);
            }
#endif
            info[key] = value;
        }
        else if ([value isKindOfClass:[NSString class]]) {
            info[key] = value;
        }
        else if ([value isKindOfClass:[NSError class]]) {
            NSError *e = value;
            NSString *message = [NSString stringWithFormat:@"%@(%ld): %@", e.domain, (long)e.code, e.localizedDescription?: @"?"];
            info[key] = message;
        }
        else {
            [info rf_setObject:[value description] forKey:key];
        }
    }
    return info;
}

@end

@implementation MBAnalyticsEvent
@end

@implementation UIViewController (MBAnalyticsPageName)

- (NSString *)pageName {
    return self.title.length? self.title : self.className;
}

- (NSDictionary *)pageAttributes {
    return nil;
}

- (BOOL)pageEventManual {
    return NO;
}

- (void)MBAnalyticsCustomEventWithSender:(id)sender attributes:(NSDictionary *)attributes {
    if (!self.mb_event.length
        || ![sender mb_event].length) return;
    NSMutableDictionary *mergedAttributes = nil;
    if (attributes.count || self.mb_eventAttributes || self.pageAttributes.count) {
        mergedAttributes = [NSMutableDictionary dictionaryWithCapacity:10];
        [mergedAttributes addEntriesFromDictionary:self.pageAttributes];
        [mergedAttributes addEntriesFromDictionary:self.mb_eventAttributes];
        [mergedAttributes addEntriesFromDictionary:attributes];
    }
// @TODO
//    [MBAnalytics fEventWithModule:self.mb_event event:[sender mb_event] attributes:mergedAttributes];
}

@end

@implementation NSObject (MBAnalyticsCustomEvent)

RFSynthesizeCategoryObjectProperty(mb_event, setMb_event, NSString *, OBJC_ASSOCIATION_COPY)
RFSynthesizeCategoryObjectProperty(mb_eventAttributes, setMb_eventAttributes, NSDictionary *, OBJC_ASSOCIATION_RETAIN)

@end
