/*!
 MBEnvironment flags
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBEnvironment.h"


/**
 关于状态
 
 MBENVFlag 描述的应该是可以持续的状态，而不是一个瞬间发生的事件，
 事件用通知、delegate 之类的响应就好了，MBEnvironment 不是干这个的。
 
 @warning MBENVFlag 状态不应持久化
 */
typedef NS_OPTIONS(MBENVFlag, MBENV) {
    //- 应用整体状态
    /// 应用现在处于前台
    MBENVFlagAppInForeground            = 1 << 0,
    
    /// 应用启动后至少进过一次前台
    MBENVFlagAppHasEnterForegroundOnce  = 1 << 1,
    
    //- 用户状态
    /// 用户已登入
    MBENVFlagUserHasLogged              = 1 << 4,
    
    /// 本次启动当前用户的用户信息已成功获取过
    MBENVFlagUserInfoFetched            = 1 << 5,
    
    //- 模块生命周期
    /// 导航已加载
    MBENVFlagNaigationLoaded                = 1 << 10,
};
