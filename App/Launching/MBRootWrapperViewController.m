
#import "MBRootWrapperViewController.h"

static MBRootWrapperViewController *MBRootWrapperViewControllerGlobalInstance;

@interface MBRootWrapperViewController ()
@end

@implementation MBRootWrapperViewController

- (UIViewController *)_styleFowardViewController {
    return self.childViewControllers.firstObject;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self._styleFowardViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self._styleFowardViewController;
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    return self._styleFowardViewController;
}

- (UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
    return self._styleFowardViewController;
}

- (UIViewController *)childViewControllerContainingSegueSource:(UIStoryboardUnwindSegueSource *)source {
    return self._styleFowardViewController;
}

- (BOOL)shouldAutorotate {
    return self._styleFowardViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self._styleFowardViewController.supportedInterfaceOrientations;
}

#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    MBRootWrapperViewControllerGlobalInstance = self;
}

+ (instancetype)globalController {
    return MBRootWrapperViewControllerGlobalInstance;
}

@end
