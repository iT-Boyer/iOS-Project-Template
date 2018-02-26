/*!
    MBRootNavigationController
    v 0.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFNavigationController.h"
#import "RFNavigationControllerTransitionDelegate.h"

@class MBControlGroup;
@class ZYCustomTipNavigationOperation;
@class MBNavigationOperation;
@class ZYTabBar;

/**
 根导航控制器
 */
@interface MBNavigationController : RFNavigationController

/**
 正在有导航进行中，再此期间的新加入的堆栈操作将会延后执行
 */
@property (readonly) BOOL navigationStackChanging;


#pragma mark - Tab

@property (nonatomic, nullable, strong) IBOutlet MBControlGroup *tabItems;

#pragma mark - 登入登出

- (void)logout;
- (void)login;


#pragma mark - 统计

/**
 每次设置都标记开始+结束一个页面，不检查重复
 
 支持嵌套，如弹出界面而不是 push，这种情形在弹出界面 dismiss 时设置 nil，即可自动重计之前页面
 */
@property (nonatomic, null_resettable, copy) NSString *pageName;

#pragma mark - 导航队列

/// 导航弹框操作队列
@property (nonatomic, nonnull, readonly) NSMutableArray<__kindof MBNavigationOperation *> *operationQueue;

/// 尝试立即处理导航队列
- (void)setNeedsPerformNavigationOperation;

/// 可以执行低优先级的导航操作
@property (readonly) BOOL shouldPerfromQunedQperation;

#pragma mark - URL 跳转

/**
 应用可以弹出模态页面或 URL 推出其它新的页面
 
 变为 YES 时处理通知中心队列的跳转，NO 时清理队列
 */
@property (readonly) BOOL isNavigationReadyForURLJump;

@end

/**
 URL 跳转，传入的 URL 会在合适的时机推出
 */
extern void APNavigationControllerJumpWithURL(id _Nullable url);

@interface MBNavigationController (AppJump)

/// 当前显示页面的 URL
- (nullable NSURL *)currentPageURL;

@end

@interface UIViewController (AppJump)
/// 当前页面的 URL，防止重复跳转到同一页面
@property (nullable, readonly) NSURL *pageURL;
@end

/**
 用于标记视图属于一个流程，
 处于流程中时，通过导航的弹窗和部分跳转将不会执行
 */
@protocol UIViewControllerIsFlowScence <NSObject>
@end


#pragma mark - 堆栈管理

/// 导航控制器切换的最短时间间隔
extern NSTimeInterval const kNavigationTransitionInterval;

@interface MBNavigationController (StackManagement)

/**
 专用弹出视图方法
 
 @param presentationStyle UIModalPresentationCurrentContext 是透明显示的，其他情况跟普通弹出一致
 */
- (void)presentViewController:(UIViewController *_Nullable)viewControllerToPresent presentationStyle:(UIModalPresentationStyle)presentationStyle animated:(BOOL)flag completion:(void (^_Nullable)(void))completion;

/**
 专用关闭模态视图方法
 */
- (void)dismissViewController:(UIViewController *_Nullable)viewController animated:(BOOL)flag completion:(void (^_Nullable)(void))completion;

- (void)popViewControllerAfter;

- (IBAction)navigationPop:(id _Nullable)sender;

@end


/**
 只是为了限定 UIAppearance 的设置范围
 */
@interface MBRootNavigationBar : UINavigationBar
@end

/// 指定是否隐藏导航栏阴影
UIKIT_EXTERN NSString *__nonnull const RFViewControllerPrefersNaigationBarShadowHiddenAttribute;
/// 导航侧滑辅助，见 UIViewController+RFDNavigationAppearance.h
UIKIT_EXTERN NSString *__nonnull const RFViewControllerPrefersNaigationPopGestureRecognizeAssistance;

typedef NS_ENUM(NSInteger, ZYNavigationTab) {
    ZYNavigationTabHome = 0,
    ZYNavigationTabCount,
    ZYNavigationTabDefault = ZYNavigationTabHome,
    ZYNavigationTabLogin = NSNotFound,
};

#import "MBNavigationOperation.h"
