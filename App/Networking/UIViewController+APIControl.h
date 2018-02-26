/*!
    UIViewController (APIControl)

    Copyright © 2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

@interface UIViewController (APIControl)

/**
 通常 API 发送的请求会传入一个 view controller 参数，用来把请求和 view controller 关联起来。
 这样，当页面销毁时，跟这个页面关联的未完成的请求可以被取消。
 
 关联的方式就是 APIGroupIdentifier 属性，默认是 view controller 的 class name。
 
 当 view controller 嵌套时，子控制器应该返回父控制器的 APIGroupIdentifier，以便整个页面销毁时，
 子控制器中的请求也可以被取消。
 */
@property (nonatomic, nonnull, copy) NSString *APIGroupIdentifier;

/// view controller 手动管理子 view controller 的 APIGroupIdentifier
@property (readonly) BOOL manageAPIGroupIdentifierManually;

@end
