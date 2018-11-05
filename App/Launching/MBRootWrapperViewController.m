
#import "MBRootWrapperViewController.h"
#import "MBNavigationController.h"
#import "UIViewController+RFInterfaceOrientation.h"
#import "Common.h"

static MBRootWrapperViewController *MBRootWrapperViewControllerGlobalInstance;

@interface MBRootWrapperViewController ()
@property (weak) UIViewController *splash;
@end

@implementation MBRootWrapperViewController

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.childViewControllers.firstObject;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.childViewControllers.firstObject;
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    return self.childViewControllers.firstObject;
}

- (UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
    return self.childViewControllers.firstObject;
}

- (UIViewController *)childViewControllerContainingSegueSource:(UIStoryboardUnwindSegueSource *)source {
    return self.childViewControllers.firstObject;
}

- (BOOL)shouldAutorotate {
    return self.childViewControllers.firstObject.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.childViewControllers.firstObject.supportedInterfaceOrientations;
}

#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    MBRootWrapperViewControllerGlobalInstance = self;
}

+ (instancetype)globalController {
    return MBRootWrapperViewControllerGlobalInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NavigationController *nav = NavigationController.newFromStoryboard;
    [self addChildViewController:nav];
    UIView *nv = nav.view;
    nv.autoresizingMask = UIViewAutoresizingFlexibleSize;
    nv.frame = self.view.bounds;
    [self.view insertSubview:nv atIndex:0];
    
    [self setupSplash];
}

#pragma mark - Splash

- (void)setupSplash {
    UIStoryboard *ls = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *vc = [ls instantiateInitialViewController];
    [self addChildViewController:vc intoView:self.view];
    self.splash = vc;
    // TODO: 移除或添加信号发送
    // 等待主页加载完毕后隐藏启动闪屏，最多等 3s
//    [AppEnv() waitFlags:MBENVFlagHomeLoaded do:^{
//        [self splashFinish];
//    } timeout:3];
//    dispatch_after_seconds(3, ^{
        [self splashFinish];
//    });
}

- (void)splashFinish {
    if (!self.splash) return;
    UIViewController *vc = self.splash;
    self.splash = nil;
    [UIView animateWithDuration:0.3 animations:^{
        vc.view.alpha = 0;
    } completion:^(BOOL finished) {
        [vc removeFromParentViewControllerAndView];
        [AppEnv() setFlagOn:MBENVFlagNaigationLoaded];
    }];
}

@end
