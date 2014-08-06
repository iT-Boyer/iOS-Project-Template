
#import "MBRootNavigationController.h"

@interface MBRootNavigationController ()
@end

@implementation MBRootNavigationController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    // 修正 iOS 6 下与按钮位置与 iOS 7 的偏差
    if (RF_iOS7Before) {
        [viewController.navigationItem.leftBarButtonItem setTitlePositionAdjustment:UIOffsetMake(-4.5, .5) forBarMetrics:UIBarMetricsDefault];
    }
}

@end

@implementation MBRootNavigationBar
@end
