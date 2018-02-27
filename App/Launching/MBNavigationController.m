
#import "MBNavigationController.h"
#import "MBApp.h"
#import "APApplicationDelegate.h"
#import "MBControlGroup.h"
#import "UIViewController+RFDNavigationAppearance.h"
#import "ZYTabBar.h"
#import "UIScrollView+RFScrolling.h"

RFDefineConstString(RFViewControllerPrefersNaigationBarShadowHiddenAttribute);
RFDefineConstString(RFViewControllerPrefersNaigationPopGestureRecognizeAssistance);
NSURL *__nullable _ZYNavigationControllerURLWaitToJump = nil;

@interface RFNavigationController ()
@property (nonatomic) UIView *bottomBarHolder;
@end

@interface MBNavigationController () <
    UIApplicationDelegate,
    UINavigationControllerDelegate
>
@property (nonatomic) IBOutlet ZYTabBar *bottomBar;
@property (nonatomic) UIView *_ZYNavigationController_popGestureHelperView;

/// 统计嵌套支持
@property (copy, nonatomic) NSString *lastPageName;
@property (nonatomic) NSPointerArray *tabControllers;

// - Part: StackManagement
@property (readonly) CFAbsoluteTime navigationStackChangeTime;
@property (readwrite) BOOL navigationStackChanging;
@property (readonly) NSMutableArray *_ZYNavigationController_delayNavigationTask;

@property (nonatomic) BOOL mb_viewDidAppear;
@end

@implementation MBNavigationController
@dynamic bottomBar;
RFUIInterfaceOrientationSupportNavigation

- (void)onInit {
    [super onInit];
    NSPointerArray *pa = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsStrongMemory];
    pa.count = ZYNavigationTabCount;
    self.tabControllers = pa;
    _operationQueue = [NSMutableArray arrayWithCapacity:10];
    __ZYNavigationController_delayNavigationTask = [NSMutableArray arrayWithCapacity:10];
    
    RFAssert(![MBApp status].globalNavigationController, @"重复设置全局导航？");
    [MBApp status].globalNavigationController = self;
    [AppDelegate() addAppEventListener:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mb_viewDidAppear = NO;
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_shadow"] forBarMetrics:UIBarMetricsDefault];
    ZYTabBar *tabBar = [ZYTabBar loadWithNibName:nil];
    self.tabItems = tabBar;
    self.bottomBar = tabBar;
    [tabBar addTarget:self action:@selector(onTabSelectionChanged:) forControlEvents:UIControlEventValueChanged];
    
    [APUser addCurrentUserChangeObserver:self initial:YES callback:^(APUser * _Nullable currentUser) {
        if (currentUser) {
            [self login];
        }
        else {
            [self logout];
        }
    }];
#if DEBUG
    BOOL launchTest = NO;
    if (launchTest) {
        self.navigationStackChanging = NO;
        // @TODO
//        [ZYDBTestViewController.new testLaunch];
    }
#endif
    [AppEnv() setFlagOn:MBENVNaigationLoaded];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.mb_viewDidAppear) {
        self.mb_viewDidAppear = YES;
    }
    [super viewDidAppear:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.navigationBarHidden) {
        return self.topViewController;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    NSUInteger idx = self.tabItems.selectIndex;
    for (int i = 0; i < self.tabControllers.count; i++) {
        if (i != idx) {
            [self.tabControllers replacePointerAtIndex:i withPointer:nil];
        }
    }
    
    [super didReceiveMemoryWarning];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // @TODO
//    if ([self.pageName isEqualToString:MBAnalyticsExitPageName]) {
//        self.pageName = nil;
//    }
    
    if (_ZYNavigationControllerURLWaitToJump
        && self.isNavigationReadyForURLJump) {
        APNavigationControllerJumpWithURL(_ZYNavigationControllerURLWaitToJump);
        return;
    }
    
    UIViewController<MBGeneralViewControllerStateTransitions> *vc = (id)self.topViewController;
    if ([vc respondsToSelector:@selector(MBViewDidAppear:)]) {
        [vc MBViewDidAppear:NO];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // @TODO
//    self.pageName = MBAnalyticsExitPageName;
}


#pragma mark - Tab

- (id)viewControllerAtIndex:(NSUInteger)index {
    RFAssert(index < ZYNavigationTabCount || index == ZYNavigationTabLogin, nil);
    id vc = [self.tabControllers pointerAtIndex:index];
    if (vc) return vc;
    
    switch (index) {
        case ZYNavigationTabHome: {
            // @TODO
//            vc = [ZYSTHomeViewController newFromStoryboard];
            break;
        }
    }
    
    [self.tabControllers replacePointerAtIndex:index withPointer:(__bridge void *)(vc)];
    return vc;
}

- (IBAction)onTabSelectionChanged:(MBControlGroup *)sender {
    @autoreleasepool {
        _dout_int(sender.selectIndex)
        
        id vc = nil;
        if (sender.selectIndex == ZYNavigationTabLogin) {
            // @TODO
//            vc = [UserWelcomeViewController newFromStoryboard];
            self.viewControllers = @[ vc ];
            return;
        }
        ZYTabBar *bar = self.bottomBar;
        switch (sender.selectIndex) {
        }
        
        vc = [self viewControllerAtIndex:sender.selectIndex];
        NSArray *newVCs = @[ vc ];
        if (![self.viewControllers isEqualToArray:newVCs]) {
            self.viewControllers = newVCs;
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (sender == self.tabItems.selectedControl) {
        return NO;
    }
    return YES;
}

- (IBAction)onSelectedTabTapped:(UIButton *)sender {
    if (!sender.selected) return;
    
    if (self.viewControllers.count > 1) {
        [self popToRootViewControllerAnimated:YES];
    }
    else {
        id vc = self.topViewController;
        if ([vc respondsToSelector:@selector(refresh)]) {
            [(id<MBGeneralListDisplaying>)vc refresh];
        }
        else if ([vc respondsToSelector:@selector(tableView)]) {
            [[(UITableViewController *)vc tableView] scrollToTopAnimated:YES];
        }
    }
}

@end

@implementation MBRootNavigationBar
@end
