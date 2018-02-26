/*!
    MBApplicationDelegate

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

/**
 关于模块加载顺序
 
 应用里有很多 manager，这些 manager 互相之间还有依赖，
 并且为了提高启动速度、减少不必要的资源使用，有些模块不想在启动时就创建好，
 
 这样带来的一个问题是模块间先后初始化不可控。
 
 有另外一个变态的需求是，我们会有静默推送的激活，
 在这种情况下只激活统计模块，其他模块不启动。
 
 UIApplicationDelegate 这么多通知调用的时机是不确定的，
 假如我们在 delegate 回调中创建这些模块，结果必然是模块创建时机不可控。
 
 为了打破这种局面，让模块创建后自己去添加监听可以避免
 因多种事件到达时机不可控导致的模块初始化顺序不可控。

 */
@interface MBApplicationDelegate : UIResponder <UIApplicationDelegate>

#pragma mark - App 生命周期记录

@property (readonly) CFAbsoluteTime applicationLaunchTime;
@property (readonly, nullable) NSDate *applicationLastLaunchTime;
@property (readonly) CFAbsoluteTime applicationLastEnterForegroundTime;
@property (readonly) CFAbsoluteTime applicationLastBecomeActiveTime;
@property (readonly) CFAbsoluteTime applicationLastEnterBackgroundTime;

#pragma mark -

@property (nonatomic, nonnull) UIWindow *window;

/**

 @warning 只有部分事件会通知 listener，见实现
 另外，多个模块的事件处理之间不应该有顺序依赖，否则可能会产生难以追查的 bug
 
 application:didReceiveRemoteNotification:fetchCompletionHandler: 事件只会调用 application:didReceiveRemoteNotification: 方法
 */
- (void)addAppEventListener:(nullable id<UIApplicationDelegate>)listener;
- (void)removeAppEventListener:(nullable id<UIApplicationDelegate>)listener;

+ (void)viewAppInAppStore;

@end

/// 快速访问 MBApplicationDelegate 实例
MBApplicationDelegate *__nonnull AppDelegate(void);
