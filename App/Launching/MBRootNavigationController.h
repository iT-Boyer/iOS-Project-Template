/*!
    MBRootNavigationController
    v 0.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <UIKit/UIKit.h>
#import "RFNavigationController.h"

/**
 根导航控制器
 */
@interface MBRootNavigationController : RFNavigationController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

/**
 只是为了限定 UIAppearance 的设置范围
 */
@interface MBRootNavigationBar : UINavigationBar
@end
