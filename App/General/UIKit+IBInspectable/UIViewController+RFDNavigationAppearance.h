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

@property IBInspectable BOOL RFPrefersBottomBarShown;

@property (nullable, copy) IBInspectable UIColor *RFPreferredNavigationBarColor;

@property IBInspectable BOOL RFPrefersLightContentBarStyle;

/**
 阻止侧滑返回手势
 */
@property IBInspectable BOOL RFPrefersDisabledInteractivePopGesture;

- (nullable NSDictionary<NSString *, id> *)RFNavigationAppearanceAttributes;

@end
