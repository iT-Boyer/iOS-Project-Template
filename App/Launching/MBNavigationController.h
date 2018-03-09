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

/**
 根导航控制器
 */
@interface MBNavigationController : RFNavigationController

/**
 隐藏导航返回按钮的文字
 
 在 didShowViewController 中设置当前 vc 的返回按钮
 */
@property BOOL prefersBackBarButtonTitleHidden;

@end

/**
 用于标记视图属于一个流程，
 处于流程中时，通过导航的弹窗和部分跳转将不会执行
 */
@protocol UIViewControllerIsFlowScence <NSObject>
@end


#pragma mark - 堆栈管理

@interface MBNavigationController (StackManagement)

- (IBAction)navigationPop:(id _Nullable)sender;

@end


/**
 
 */
@interface MBRootNavigationBar : UINavigationBar
@end

/// 指定是否隐藏导航栏阴影
UIKIT_EXTERN NSString *__nonnull const RFViewControllerPrefersNaigationBarShadowHiddenAttribute;
/// 导航侧滑辅助，见 UIViewController+RFDNavigationAppearance.h
UIKIT_EXTERN NSString *__nonnull const RFViewControllerPrefersNaigationPopGestureRecognizeAssistance;

#import "MBNavigationOperation.h"
