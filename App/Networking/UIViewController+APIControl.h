/*!
    UIViewController (APIControl)

    Copyright © 2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <UIKit/UIKit.h>

@interface UIViewController (APIControl)

/**
 完善请求取消的控制，解决 view controller 嵌套不能正确取消子控制器中的请求
 子控制器应该返回父控制器的 APIGroupIdentifier，返回 nil 时使用 receiver 的 class name
 */
@property (nonatomic, copy) NSString *APIGroupIdentifier;

@end
