//
//  MBEnvironment.h
//  Feel
//
//  Created by BB9z on 23/12/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

typedef int32_t MBENVFlag;

/**
 状态管理 manager
 
 背景
 -----
 
    之前为了解决模块互相依赖，防止互相创建导致死循环发生，把模块创建跟调用通过监听的方式分离开来。既然代码不能主动创建模块了，如果调用时模块不存在怎么办，如果依赖多个模块又怎么写？
 
    同时，我们希望业务能跟模块代码分开，设想登录成功后用户模块要调一大堆的业务代码会有多难看。那这些业务逻辑又能在哪里写，由谁去调用呢？
 
    MBEnvironment 就是为了解决上面两个问题存在的，它可以通过指定多个状态，当这些状态同时满足时做给定的事。

 */
@interface MBEnvironment : NSObject

/**
 状态监听回调执行的队列
 
 默认在主线程队列
 */
@property (nonatomic, null_resettable) dispatch_queue_t queue;

/// 当前状态是否满足指定状态
- (BOOL)meetFlags:(MBENVFlag)flags;

/// 标记状态开启
- (void)setFlagOn:(MBENVFlag)flag;

/// 标记状态关闭
- (void)setFlagOff:(MBENVFlag)flag;

#pragma mark -

/**
 若状态符合指定状态，立即执行一个 block，否则等待直到状态满足时执行

 @param flags 需要的状态
 @param block 如果调用方法时状态符合，block 将在当前线程调用；block 若没有立即调用，之后会在 在 queue 队列调用
 @param timeout 等待状态符合的最长时间，超出后将不等待，0 无限制
 */
- (void)waitFlags:(MBENVFlag)flags do:(nonnull dispatch_block_t)block timeout:(NSTimeInterval)timeout;

#pragma mark - 监听

/**
 注册一个状态变化的监听，每次状态从不符合变化到符合时调用
 
 如果注册时当前状态符合指定的状态，并不会调用回调

 @param flags 需要的状态
 @param handler 状态从不符合变化到符合时调用的回调，在 queue 队列调用
 @return 监听辅助对象，用于移除监听
 */
- (nonnull id)registerFlagsObserver:(MBENVFlag)flags handler:(nonnull dispatch_block_t)handler;

/**
 移除状态监听

 @param observer 注册监听时返回的辅助对象
 */
- (void)removeFlagsObserver:(nullable id)observer;

#pragma mark - 默认状态响应

/**
 关于默认状态响应
 ------
 
    我们有了 registerFlagsObserver:handler: 方法，可以监听满足指定状态的要求。
    但我们有一些固定的时机要执行固定的逻辑，如果都通过加 block 监听，要写多少代码，又在哪写呢？都加 block，多了对内存也不友好。
    
    为了解决这些问题，需要建一种新机制：
    - 创建 MBEnvironment 的 category，在 category 里写状态变化响应的业务代码
    - category load 方法中添加静态监听，把 category 里写的业务方法和期望的状态关联起来
    - 创建 MBEnvironment 实例，注册为应用默认环境，只有默认环境才会响应 category 里注册的静态监听
 */

/**
 注册静态状态响应

 @param flags 需要的状态
 @param selector 状态满足时尝试调用的方法
 @param handleOnce 调用一次后移除
 */
+ (void)staticObserveFlag:(MBENVFlag)flags selector:(nonnull SEL)selector handleOnce:(BOOL)handleOnce;

/**
 注册应用默认的环境，默认环境当状态变化时会调用静态监听
 */
+ (void)setAsApplicationDefaultEnvironment:(nonnull MBEnvironment *)env;

@end


/**
 关于状态
 
    MBENVFlag 描述的应该是可以持续的状态，而不是一个瞬间发生的事件，
    事件用通知、delegate 之类的响应就好了，MBEnvironment 不是干这个的。

 @warning MBENVFlag 状态不应持久化
 */
typedef NS_OPTIONS(MBENVFlag, MBEnvironmentFlag) {
    //- 应用整体状态
    /// 应用现在处于前台
    MBENVAppInForeground                = 1 << 0,

    /// 应用启动后至少进过一次前台
    MBENVAppHasEnterForegroundOnce      = 1 << 1,

    //- 用户状态
    /// 用户已登入
    MBENVUserHasLogged                  = 1 << 5,

    /// 本次启动当前用户的用户信息已成功获取过
    MBENVUserInfoFetched                = 1 << 6,

    //- 模块生命周期
    /// 导航已加载
    MBENVNaigationLoaded                = 1 << 10,
    
    /// 主页，dashboard 已获取
    MBENVMainViewReady                  = 1 << 11,
    
    /// 主页，打卡详情已成功加载过
    MBENVMainViewHasDetailFetched       = 1 << 12,
};

