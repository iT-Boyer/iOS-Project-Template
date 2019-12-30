/*
 MBShareManager
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <RFKit/RFRuntime.h>
#import <MBAppKit/MBGeneralCallback.h>

/// 分享类型
typedef NS_ENUM(int, MBShareType) {
    MBShareTypeInvaild = -1,
    
    /// 微信好友
    MBShareTypeWechatSession,
    
    /// 微信朋友圈
    MBShareTypeWechatTimeline,
    
    /// 微信收藏
    MBShareTypeWechatFavorite,

    /// QQ
    MBShareTypeQQSession,
};


typedef NSString * MBSocailLoginResultKey NS_TYPED_ENUM;

/**
 分享
 
 微信原生的分享
 
 ## 集成
 
 - Info.plist 中 LSApplicationQueriesSchemes 数组添加 wexin
 - Info.plist 中 CFBundleURLTypes 数组中添加微信的跳转，形如
 
     <dict>
         <key>CFBundleTypeRole</key>
         <string>Editor</string>
         <key>CFBundleURLName</key>
         <string>weixin</string>
         <key>CFBundleURLSchemes</key>
         <array>
             <string>wxd930ea5d5a258f4f</string>
         </array>
     </dict>
 
 - AppDelegate() 必须是 MBApplicationDelegate
 - 微信 SDK 可通过 pod 'WechatOpenSDK' 导入
 
 ## 特殊注意
 
 因为微信 SDK 回调机制的缺陷，当用户分享后没有立即返回 app，回调可能收不到。这种情况 MBShareManager 当作取消处理，因而取消不应提示给用户。
 
 */
@interface MBShareManager : NSObject

@property (class, readonly, nonnull) MBShareManager *defaultManager;

/// 应用启动后调用
- (void)setupWithApplication:(nonnull UIApplication *)application launchingOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions;

/// 是否可以分享到微信
@property (class, readonly) BOOL isWechatEnabled;
/// 是否可以分享到 QQ
@property (class, readonly) BOOL isQQEnabled;

#pragma mark - 分享

/**
 分享链接

 @param thumb QQ 分享时可以是 UIImage 或 NSURL，微信暂时只支持 UIImage
 */
- (void)shareLink:(nonnull NSURL *)link title:(nonnull NSString *)title description:(nullable NSString *)description thumbImage:(nullable id)thumb type:(MBShareType)type callback:(nullable MBGeneralCallback)callback;

/// 分享图片
- (void)shareImage:(nonnull UIImage *)image type:(MBShareType)type callback:(nullable MBGeneralCallback)callback;

#pragma mark - 三方登入

- (void)loginWechatComplation:(nullable MBGeneralCallback)callback;

- (void)loginQQComplation:(nullable MBGeneralCallback)callback;

@end

NS_ASSUME_NONNULL_BEGIN
// 下面是第三方登录结果的字段
UIKIT_EXTERN MBSocailLoginResultKey const MBSocailLoginResultTokenKey     NS_SWIFT_NAME(token);
UIKIT_EXTERN MBSocailLoginResultKey const MBSocailLoginResultUserIDKey     NS_SWIFT_NAME(userID);
/// 过期时间，NSDate
UIKIT_EXTERN MBSocailLoginResultKey const MBSocailLoginResultExpirationKey     NS_SWIFT_NAME(expiration);

NS_ASSUME_NONNULL_END

@protocol MBEntitySharing
@optional
- (void)shareLinkWithType:(MBShareType)type callback:(nullable MBGeneralCallback)callback;
@end
