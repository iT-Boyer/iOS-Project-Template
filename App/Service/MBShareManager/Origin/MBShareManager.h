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
};

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

/// 是否可以分享到微信
@property (class, readonly) BOOL isWechatEnabled;

/// 分享链接
- (void)shareLink:(nonnull NSURL *)link title:(nonnull NSString *)title description:(nullable NSString *)description thumbImage:(nullable UIImage *)thumb type:(MBShareType)type callback:(nullable MBGeneralCallback)callback;

/// 分享图片
- (void)shareImage:(nonnull UIImage *)image type:(MBShareType)type callback:(nullable MBGeneralCallback)callback;

@end

@protocol MBEntitySharing
@optional
- (void)shareLinkWithType:(MBShareType)type callback:(nullable MBGeneralCallback)callback;
@end
