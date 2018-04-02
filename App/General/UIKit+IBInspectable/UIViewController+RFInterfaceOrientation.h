/*!
 UIViewController+RFInterfaceOrientation
 
 Copyright © 2018 RFUI. All rights reserved.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <UIKit/UIKit.h>

/**
 在 Interface Builder 中直接定义 vc 支持的设备方向
 */
@interface UIViewController (RFInterfaceOrientation)

/**
 0 默认或未设置，支持所有方向
 1 锁定竖屏
 2 锁定横屏
 */
@property IBInspectable NSInteger RFInterfaceOrientation;

@property (readonly) BOOL RFInterfaceOrientationSet;

@end
