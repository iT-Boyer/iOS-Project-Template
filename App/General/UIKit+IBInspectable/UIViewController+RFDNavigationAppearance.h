/*
 UIViewController+RFDNavigationAppearance
 
 Copyright © 2016-2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <RFAlpha/RFNavigationController.h>

@interface UIViewController (RFDNavigationAppearance)

@property IBInspectable BOOL RFPrefersStatusBarHidden;

@property IBInspectable BOOL RFPrefersNavigationBarHidden;

@property IBInspectable BOOL RFPrefersBottomBarShown;

@property (nullable, copy) IBInspectable UIColor *RFPreferredNavigationBarColor;

@property IBInspectable BOOL RFPrefersLightContentBarStyle;

/**
 阻止侧滑返回手势
 */
@property IBInspectable BOOL RFPrefersDisabledInteractivePopGesture;

- (nullable NSMutableDictionary<RFViewControllerAppearanceAttributeKey, id> *)RFNavigationAppearanceAttributes;

@end
