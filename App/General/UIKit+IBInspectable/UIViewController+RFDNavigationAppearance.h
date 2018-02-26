//
//  UIViewController+RFDNavigationAppearance.h
//  RFDemo
//
//  Created by BB9z on 8/11/16.
//  Copyright © 2016 RFUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RFDNavigationAppearance)

@property IBInspectable BOOL RFPrefersStatusBarHidden;

@property IBInspectable BOOL RFPrefersNavigationBarHidden;

@property IBInspectable BOOL RFPrefersNavigationBarShadowHidden;

@property IBInspectable BOOL RFPrefersBottomBarShown;

@property (nullable, copy) IBInspectable UIColor *RFPreferredNavigationBarColor;

@property IBInspectable BOOL RFPrefersLightContentBarStyle;

/**
 侧滑返回手势可能因界面中的手势优先被识别而失效，开启该属性可以帮助返回手势被优先处理
 
 一般来说，返回手势被抢断，多数是界面中存在 scrollView，这种情况的标准做法是在界面显示后执行：
 
 @code
 [scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
 @endcode
 
 缺点是需要根据具体情况在每处手写控制，不够通用。
 
 这个属性的解决方案是在 view controller 视图上面覆盖一个靠在屏幕左侧的辅助 view，从而防止侧滑手势被忽略，同时因为这个辅助 view 宽度很小，正常也不影响视图上的手势识别。
 */
@property IBInspectable BOOL RFPrefersPopGestureRecognizeAssistance;

/**
 阻止侧滑返回手势
 */
@property IBInspectable BOOL RFPrefersDisabledInteractivePopGesture;

- (nullable NSDictionary<NSString *, id> *)RFNavigationAppearanceAttributes;

@end
