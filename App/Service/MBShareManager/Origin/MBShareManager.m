
#import "MBShareManager.h"
#import <WechatOpenSDK/WXApi.h>
#import <WechatOpenSDK/WXApiObject.h>
#import "Common.h"

@interface MBShareManager () <
    UIApplicationDelegate,
    WXApiDelegate
>
@property MBGeneralCallback lastCallback;
@property MBGeneralCallback restoreCallback;
@end

@implementation MBShareManager

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
    NSString *appid = self.class.wechatAppID;
    RFAssert(appid.length, @"请先在 Info.plist 中设置微信的回调链接");
    [WXApi registerApp:appid];
    return self;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    douto(url)
    if ([url.scheme hasPrefix:@"wx"]) {
        // 是微信回调，支付回调不应处理
        if ([url.host isEqualToString:@"pay"]) return NO;
    }
    if ([WXApi handleOpenURL:url delegate:self]) return YES;
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
    self.restoreCallback = nil;
    self.lastCallback = nil;
    cb(NO, nil, nil);
}

// 微信终端向第三方程序发起请求，要求第三方程序响应
// 第三方程序响应完后必须调用sendRsp返回
// 在调用sendRsp返回时，会切回到微信终端程序界面
- (void)onReq:(BaseReq *)req {
    
}

// 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调
// sendReq 请求调用后，会切到微信终端程序界面
- (void)onResp:(BaseResp *)resp {
    dout(@"MBShareManager> Wechat response: %@(%d) %@", resp.class, resp.errCode, resp.errStr);
    MBGeneralCallback cb = self.lastCallback;
    self.lastCallback = nil;
    if (!cb) return;
    if (resp.errCode == WXSuccess) {
        cb(YES, nil, nil);
        return;
    }
    if (resp.errCode == WXErrCodeUserCancel) {
        cb(NO, nil, nil);
        return;
    }
    NSString *des = resp.errStr;
    cb(NO, nil, [NSError errorWithDomain:self.className code:resp.errCode localizedDescription:des]);
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

#pragma mark -

// 分享调用 https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&id=open1419317332

- (void)shareLink:(NSURL *)link title:(NSString *)title description:(NSString *)description thumbImage:(UIImage *)thumb type:(MBShareType)type callback:(MBGeneralCallback)callback {
    MBGeneralCallback cb = MBSafeCallback(callback);
    
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

@end
