/*!
 MBNavigationController+Router
 
 Copyright © 2018, 2020 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */
#import "MBNavigationController.h"

/**
 一个简易静态的路由实现
 */
@interface MBNavigationController (Router)

/// 仅供导航内部使用，外部请使用 AppNavigationJump() 方法
- (void)jumpWithURL:(nullable NSString *)url object:(nullable id)object;

/// 当前显示页面的 URL
- (nullable NSURL *)currentPageURL;

@end

/**
 应用支持的跳转

 http/https 链接，打开 Safari；
 其它跳转需要以 APP_SCHEME:// 起始
 */
FOUNDATION_EXPORT void AppNavigationJump(NSString *__nullable url, id __nullable additonalObject);

/// 应用的自定义 scheme
FOUNDATION_EXPORT NSString *__nonnull const AppScheme;

// 没有实现，需要 vc 自己按需实现
@interface UIViewController (AppJump)
/// 当前页面的 URL，防止重复跳转到同一页面
@property (nullable, readonly) NSURL *pageURL;
@end
