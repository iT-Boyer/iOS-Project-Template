
#import "MBRootWrapperViewController.h"
#import "MBNavigationController.h"
#import "UIViewController+RFInterfaceOrientation.h"
#import "Common.h"

static MBRootWrapperViewController *MBRootWrapperViewControllerGlobalInstance;

@interface MBRootWrapperViewController ()
@property (weak, nonatomic) UIView *snapRenderingContainer;
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

#pragma mark - Snap render

- (UIView *)snapRenderingContainer {
    if (_snapRenderingContainer) return _snapRenderingContainer;

    UIView *v = [UIView new];
    v.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view insertSubview:v atIndex:0];
    _snapRenderingContainer = v;
    return _snapRenderingContainer;
}

@end


@implementation MBRootWrapperViewController (ViewSnap)

- (void)setupRenderView:(UIView *)viewToRendering width:(CGFloat)width {
    BOOL hasWidth = (width != CGFLOAT_MAX);
    UIView *rc = self.snapRenderingContainer;
    if (hasWidth) {
        rc.width = width;
    }
    [rc addSubview:viewToRendering];

    [rc addConstraint:[NSLayoutConstraint constraintWithItem:rc attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:viewToRendering attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [rc addConstraint:[NSLayoutConstraint constraintWithItem:rc attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewToRendering attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    if (hasWidth) {
        [rc addConstraint:[NSLayoutConstraint constraintWithItem:rc attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:viewToRendering attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    viewToRendering.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupRenderView:(UIView *)viewToRendering {
    UIView *rc = self.snapRenderingContainer;
    rc.size = viewToRendering.size;
    [rc addSubview:viewToRendering];
}

- (UIImage *)renderThenClean {
    RFAssert(self.snapRenderingContainer.subviews.count == 1, @"Rendering Container 里的图层数量对不上了");
    UIView *r = self.snapRenderingContainer.subviews.lastObject;
    if (!r) return nil;

    [r layoutIfNeeded];
    UIGraphicsBeginImageContextWithOptions(r.bounds.size, r.opaque, 2);
    [r.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.snapRenderingContainer removeAllSubviews];
    RFAssert(img, @"生成图片失败");
    return img;
}

- (UIImage *)renderThenCleanWithView:(UIView *)viewToRendering {
    RFAssert(viewToRendering, nil);
    UIView *r = viewToRendering;
    if (!r) return nil;

    [r layoutIfNeeded];
    UIGraphicsBeginImageContextWithOptions(r.bounds.size, r.opaque, 2);
    [r.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.snapRenderingContainer removeSubview:r];
    RFAssert(img, @"生成图片失败");
    return img;
}

@end

