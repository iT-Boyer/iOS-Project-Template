
#import "MBShareManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WechatOpenSDK/WXApi.h>
#import <WechatOpenSDK/WXApiObject.h>
#import "Common.h"

static BOOL g_WechatRegisterFlag = NO;

@interface MBShareManager () <
    UIApplicationDelegate,
    QQApiInterfaceDelegate,
    TencentSessionDelegate,
    WXApiDelegate
>
@property MBGeneralCallback lastCallback;
@property MBGeneralCallback restoreCallback;
@property (null_resettable, nonatomic) TencentOAuth *qqAuthObject;
@end

@implementation MBShareManager

+ (instancetype)defaultManager {
    static id sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    [AppDelegate() addAppEventListener:self];
    return self;
}

- (void)setupWithApplication:(UIApplication *)application launchingOptions:(NSDictionary *)launchOptions {
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    douto(url)
    if ([url.scheme hasPrefix:@"wx"]) {
        // 是微信回调，支付回调不应处理
        if ([url.host isEqualToString:@"pay"]) return NO;
    }
    if ([WXApi handleOpenURL:url delegate:self]) return YES;
    if ([QQApiInterface handleOpenURL:url delegate:self]) return YES;
    if ([TencentOAuth CanHandleOpenURL:url]) {
        if ([TencentOAuth HandleOpenURL:url]) return YES;
    }
    return NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.restoreCallback = self.lastCallback;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    MBGeneralCallback cb = self.lastCallback;
    if (!cb) {
        self.restoreCallback = nil;
        return;
    }
    if (self.restoreCallback != cb) return;
    // 切换到微信、QQ 手动返回或取消返回，SDK 不会调通知方法，需手动取消
    self.restoreCallback = nil;
    self.lastCallback = nil;
    self.qqAuthObject = nil;
    cb(NO, nil, nil);
}

#pragma mark - WeChat 通讯

+ (NSString *)wechatAppID {
    for (NSDictionary *item in NSBundle.mainBundle.infoDictionary[@"CFBundleURLTypes"]) {
        NSArray<NSString *> *schemes = item[@"CFBundleURLSchemes"];
        if (![schemes isKindOfClass:NSArray.class]) continue;
        NSString *s = schemes.firstObject;
        if (![s isKindOfClass:NSString.class]) continue;
        if ([s hasPrefix:@"wx"]) {
            return s;
        }
    }
    return nil;
}

+ (void)registerWechatIfNeeded {
    if (g_WechatRegisterFlag) return;
    NSString *appid = self.wechatAppID;
    RFAssert(appid.length, @"请先在 Info.plist 中设置微信的回调链接");
    [WXApi registerApp:appid];
    g_WechatRegisterFlag = YES;
}

// 微信终端向第三方程序发起请求，要求第三方程序响应
// 第三方程序响应完后必须调用sendRsp返回
// 在调用sendRsp返回时，会切回到微信终端程序界面
- (void)onReq:(id)req {
    
}

// 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调
// sendReq 请求调用后，会切到微信终端程序界面
- (void)onResp:(id)response {
    if ([response isKindOfClass:BaseResp.class]) {
        __kindof BaseResp *resp = response;
        dout(@"MBShareManager> Wechat response: %@(%d) %@", resp.class, resp.errCode, resp.errStr);
        MBGeneralCallback cb = self.lastCallback;
        self.lastCallback = nil;
        if (!cb) return;

        if ([resp isKindOfClass:SendAuthResp.class]) {
            // 登入的响应有诸多特殊情形要处理，摘出来
            SendAuthResp *r = resp;
            NSString *code = r.code;

            if (resp.errCode == WXSuccess
                && code.length) {
                cb(YES, @{ MBSocailLoginResultTokenKey: code }, nil);
                return;
            }
            // 除以上外全失败

            if (resp.errCode == WXErrCodeUserCancel
                // 无错误信息当成取消
                || !resp.errStr.length) {
                cb(NO, nil, nil);
                return;
            }
            cb(NO, nil, [NSError errorWithDomain:@"Wechat" code:resp.errCode localizedDescription:resp.errStr]);
            return;
        }   // END: SendAuthResp 特殊处理

        switch (resp.errCode) {
            case WXSuccess:
                cb(YES, nil, nil);
                return;
            case WXErrCodeUserCancel:
                cb(NO, nil, nil);
                return;
            default:
                cb(NO, nil, [NSError errorWithDomain:@"Wechat" code:resp.errCode localizedDescription:resp.errStr]);
                return;
        }
    }   // END: Wechat resp
    else {
        QQBaseResp *resp = response;
        dout(@"MBShareManager> QQ response: %@ %@ %@", resp.result, resp.errorDescription, resp.extendInfo);
        self.qqAuthObject = nil;

        MBGeneralCallback cb = self.lastCallback;
        self.lastCallback = nil;
        if (!cb) return;
        int r = resp.result.intValue;
        switch (r) {
            case 0:
                cb(YES, nil, nil);
                return;
            case -4:
                cb(NO, nil, nil);
                return;

            default:
                cb(NO, nil, [NSError errorWithDomain:self.className code:r localizedDescription:resp.errorDescription]);
                return;
        }
    }   // END: QQ resp
}

+ (int)WXSceneFromType:(MBShareType)type {
    switch (type) {
        case MBShareTypeWechatSession:
            return WXSceneSession;
        case MBShareTypeWechatTimeline:
            return WXSceneTimeline;
        case MBShareTypeWechatFavorite:
            return WXSceneFavorite;
        default:
            return MBShareTypeInvaild;
    }
}

+ (BOOL)isWechatEnabled {
    return [UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

- (BOOL)_prepareWechatShareWithCB:(MBGeneralCallback)cb {
    if (!self.class.isWechatEnabled) {
        cb(NO, nil, [NSError errorWithDomain:self.className code:0 localizedDescription:@"你未安装微信，无法进行分享，请下载安装最新版微信"]);
        return NO;
    }
    [self.class registerWechatIfNeeded];
    return YES;
}

#pragma mark - QQ 通讯

+ (NSString *)qqAppID {
    for (NSDictionary *item in NSBundle.mainBundle.infoDictionary[@"CFBundleURLTypes"]) {
        NSArray<NSString *> *schemes = item[@"CFBundleURLSchemes"];
        if (![schemes isKindOfClass:NSArray.class]) continue;
        NSString *s = schemes.firstObject;
        if (![s isKindOfClass:NSString.class]) continue;
        if ([s hasPrefix:@"tencent"]) {
            return [s stringByReplacingOccurrencesOfString:@"tencent" withString:@""];
        }
    }
    return nil;
}

- (void)tencentDidLogin {
    TencentOAuth *oa = self.qqAuthObject;
    self.qqAuthObject = nil;

    MBGeneralCallback cb = self.lastCallback;
    self.lastCallback = nil;
    if (!cb) return;

    if (!oa.accessToken.length) {
        cb(NO, nil, [NSError errorWithDomain:self.className code:MBErrorDataInvaild localizedDescription:@"token 字段缺失"]);
        return;
    }
    NSMutableDictionary *info = [NSMutableDictionary.alloc initWithCapacity:3];
    [info rf_setObject:oa.accessToken forKey:MBSocailLoginResultTokenKey];
    [info rf_setObject:oa.openId forKey:MBSocailLoginResultUserIDKey];
    [info rf_setObject:oa.expirationDate forKey:MBSocailLoginResultExpirationKey];
    cb(YES, info, nil);
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    RFAssert(cancelled, nil); // 似乎只有取消能触发
    self.qqAuthObject = nil;

    MBGeneralCallback cb = self.lastCallback;
    self.lastCallback = nil;
    if (!cb) return;

    cb(NO, nil, nil);
}

- (void)tencentDidNotNetWork {
    self.qqAuthObject = nil;

    MBGeneralCallback cb = self.lastCallback;
    self.lastCallback = nil;
    if (!cb) return;

    cb(NO, nil, [NSError errorWithDomain:self.className code:0 localizedDescription:@"因网络问题无法登录，请检查网络"]);
}

- (void)isOnlineResponse:(NSDictionary *)response {

}

+ (BOOL)isQQEnabled {
    return [QQApiInterface isSupportShareToQQ];
}

- (TencentOAuth *)qqAuthObject {
    if (_qqAuthObject) return _qqAuthObject;
    NSString *appid = self.class.qqAppID;
    RFAssert(appid.length, @"请先在 Info.plist 中设置 tencent 回调链接");
    _qqAuthObject = [TencentOAuth.alloc initWithAppId:appid andDelegate:self];
    return _qqAuthObject;
}

- (void)sendQQContent:(__kindof QQApiObject *)content callback:(MBGeneralCallback)cb {
    SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:content];
    QQApiSendResultCode r = [QQApiInterface sendReq:request];
    if (r == EQQAPISENDSUCESS) {
        self.lastCallback = cb;
        return;
    }
    if (r == EQQAPIQQNOTINSTALLED) {
        cb(NO, nil, [NSError errorWithDomain:self.className code:r localizedDescription:@"QQ 未安装"]);
    }
    else {
        cb(NO, nil, [NSError errorWithDomain:self.className code:r localizedDescription:@"调起 QQ 失败"]);
    }
}

#pragma mark - 分享

// 分享调用 https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&id=open1419317332

- (void)shareLink:(NSURL *)link title:(NSString *)title description:(NSString *)description thumbImage:(id)thumb type:(MBShareType)type callback:(MBGeneralCallback)callback {
    MBGeneralCallback cb = MBSafeCallback(callback);
    if (type == MBShareTypeQQSession) {
        [self qqAuthObject];            // 分享前 auth 对象需要存在

        QQApiNewsObject *content = nil;
        if ([thumb isKindOfClass:NSURL.class]) {
            content = [QQApiNewsObject objectWithURL:link title:title description:nil previewImageURL:(NSURL *)thumb];
        }
        else if ([thumb isKindOfClass:UIImage.class]) {
            NSData *imageData = UIImageJPEGRepresentation((UIImage *)thumb, 0.8);
            NSData *thumbData = [self preparedThumbImageFromData:imageData shareType:type];
            content = [QQApiNewsObject objectWithURL:link title:title description:nil previewImageData:imageData];
            content.previewImageData = thumbData;
        }
        content.cflag = kQQAPICtrlFlagQQShare;
        [self sendQQContent:content callback:cb];
        return;
    }

    if (![self _prepareWechatShareWithCB:cb]) return;

    WXMediaMessage *message = WXMediaMessage.message;
    message.title = title;
    message.description = description;
    [message setThumbImage:thumb];
    
    WXWebpageObject *ext = WXWebpageObject.object;
    ext.webpageUrl = link.absoluteString;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = SendMessageToWXReq.new;
    req.bText = NO;
    req.message = message;
    req.scene = [self.class WXSceneFromType:type];
    
    if ([WXApi sendReq:req]) {
        self.lastCallback = cb;
        return;
    }
    cb(NO, nil, [NSError errorWithDomain:self.className code:0 localizedDescription:@"调起微信失败"]);
}

- (void)shareImage:(UIImage *)image type:(MBShareType)type callback:(MBGeneralCallback)callback {
    MBGeneralCallback cb = MBSafeCallback(callback);
    if (type == MBShareTypeQQSession) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        NSData *thumbData = [self preparedThumbImageFromData:imageData shareType:type];

        [self qqAuthObject];            // 分享前 auth 对象需要存在

        QQApiImageObject *content = [QQApiImageObject.alloc initWithData:imageData previewImageData:thumbData title:nil description:nil];
        content.cflag = kQQAPICtrlFlagQQShare;
        [self sendQQContent:content callback:cb];
        return;
    }
    if (![self _prepareWechatShareWithCB:cb]) return;

    WXImageObject *imageObject = WXImageObject.object;
    imageObject.imageData = UIImageJPEGRepresentation(image, 0.6);
    
    WXMediaMessage *message = WXMediaMessage.message;
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = SendMessageToWXReq.new;
    req.bText = NO;
    req.message = message;
    req.scene = [self.class WXSceneFromType:type];
    
    if ([WXApi sendReq:req]) {
        self.lastCallback = cb;
        return;
    }
    cb(NO, nil, [NSError errorWithDomain:self.className code:0 localizedDescription:@"调起微信失败"]);
}

#pragma mark - 第三方登录

- (void)loginWechatComplation:(MBGeneralCallback)callback {
    [self.class registerWechatIfNeeded];
    MBGeneralCallback cb = MBSafeCallback(callback);
    SendAuthReq *req = SendAuthReq.new;
    req.scope = @"snsapi_userinfo";
    req.state = UIDevice.currentDevice.identifierForVendor.UUIDString;

    if ([WXApi sendReq:req]) {
        self.lastCallback = cb;
        return;
    }
    if (!self.class.isWechatEnabled) {
        cb(NO, nil, [NSError errorWithDomain:self.className code:0 localizedDescription:@"微信未安装"]);
        return;
    }
    cb(NO, nil, [NSError errorWithDomain:self.className code:0 localizedDescription:@"调起微信失败"]);
}

- (void)loginQQComplation:(MBGeneralCallback)callback {
    MBGeneralCallback cb = MBSafeCallback(callback);
    NSArray *permissions = @[
                             kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                             kOPEN_PERMISSION_GET_USER_INFO,
                             kOPEN_PERMISSION_GET_INFO,
                             kOPEN_PERMISSION_GET_OTHER_INFO ];
    self.lastCallback = cb;
    self.qqAuthObject.authMode = kAuthModeClientSideToken;
    // QQ 在 authorize 方法调用内部有时就调结果，需要先设置 qqAuthObject 和 lastCallback
    if ([self.qqAuthObject authorizeWithQRlogin: permissions]) {
        return;
    }
    self.qqAuthObject = nil;
    self.lastCallback = nil;
    cb(NO, nil, [NSError errorWithDomain:self.className code:0 localizedDescription:@"调起 QQ 认证失败"]);
}

- (nullable NSData *)preparedThumbImageFromData:(nonnull NSData *)data shareType:(MBShareType)type {
    RFAssert(data, nil);
    NSInteger maxLength = NSIntegerMax;
    switch (type) {
        case MBShareTypeWechatSession:
        case MBShareTypeWechatTimeline:
        case MBShareTypeWechatFavorite:
            maxLength = 32000;
            break;
        case MBShareTypeQQSession:
            maxLength = 1000000;
        default:
            break;
    }

    @autoreleasepool {
        if (data.length > maxLength) {
            UIImage *image = [UIImage imageWithData:data scale:2];
            image = [image imageAspectFillSize:CGSizeMake(120, 120) opaque:YES scale:2];
            if (!image) return nil;

            double quality = 0.6;
            do {
                data = UIImageJPEGRepresentation(image, quality);
                dout_int(data.length)
                if (!data) return nil;
                quality *= .7;
            } while (data.length > maxLength && quality > .1);
        }
    }
    return data;
}

@end

MBSocailLoginResultKey const MBSocailLoginResultTokenKey = @"token";
MBSocailLoginResultKey const MBSocailLoginResultUserIDKey = @"userID";
MBSocailLoginResultKey const MBSocailLoginResultExpirationKey = @"expiration";

