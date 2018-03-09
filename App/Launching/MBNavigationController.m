
#import "MBNavigationController.h"
#import "MBApp.h"
#import "APApplicationDelegate.h"

@interface MBNavigationController () <
    UIApplicationDelegate,
    UINavigationControllerDelegate
>
@end

@implementation MBNavigationController
RFUIInterfaceOrientationSupportNavigation

- (void)onInit {
    [super onInit];
    
    RFAssert(![MBApp status].globalNavigationController, @"重复设置全局导航？");
    [MBApp status].globalNavigationController = self;
    [AppDelegate() addAppEventListener:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [AppEnv() setFlagOn:MBENVNaigationLoaded];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.navigationBarHidden) {
        return self.topViewController;
    }
    return nil;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    UIViewController<MBGeneralViewControllerStateTransitions> *vc = (id)self.topViewController;
    if ([vc respondsToSelector:@selector(MBViewDidAppear:)]) {
        [vc MBViewDidAppear:NO];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super navigationController:navigationController didShowViewController:viewController animated:animated];
    
    if (self.prefersBackBarButtonTitleHidden) {
        if (!viewController.navigationItem.backBarButtonItem) {
            viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        }
    }
}

@end

@implementation MBRootNavigationBar
@end

#pragma mark - StackManagement

@implementation MBNavigationController (StackManagement)

- (IBAction)navigationPop:(id)sender {
    [self popViewControllerAnimated:YES];
}

@end

