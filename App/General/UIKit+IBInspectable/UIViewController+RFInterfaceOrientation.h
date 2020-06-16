/*
 UIViewController+RFInterfaceOrientation
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */
#import <UIKit/UIKit.h>

/**
 在 Interface Builder 中直接定义 vc 支持的设备方向
 */
@interface UIViewController (RFInterfaceOrientation)

/**
 0 锁定竖屏
 1 锁定横屏
 2 支持所有方向
 */
@property IBInspectable NSInteger RFInterfaceOrientation;

@property (readonly) BOOL RFInterfaceOrientationSet;

@end
