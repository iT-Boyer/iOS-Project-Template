
#import "MBRootWrapperViewController.h"
#import "MBNavigationController.h"
#import "UIViewController+RFInterfaceOrientation.h"

static char _rf_category_RFInterfaceOrientation;
static MBRootWrapperViewController *MBRootWrapperViewControllerGlobalInstance;

@interface MBRootWrapperViewController ()
@property (nonatomic) BOOL hasViewAppeared;
@property (weak, nonatomic) UIView *snapRenderingContainer;
@property (weak) UINavigationController *MBNavigationController;
@end

@implementation MBRootWrapperViewController

- (BOOL)shouldAutorotate {
    return self._styleViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *vc = self._styleViewController;
    if (objc_getAssociatedObject(vc, &_rf_category_RFInterfaceOrientation)) {
        int o = vc.RFInterfaceOrientation;
        if (o == 1) {
            return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
        }
        else if (o == 2) {
            return UIInterfaceOrientationMaskLandscape;
        }
        return UIInterfaceOrientationMaskAll;
    }
    return vc.supportedInterfaceOrientations;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self._styleViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self._styleViewController;
}

- (UIViewController *)_styleViewController {
    UINavigationController *vc = self.childViewControllers.lastObject;
    return [vc isKindOfClass:UINavigationController.class]? vc.visibleViewController : vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    MBRootWrapperViewControllerGlobalInstance = self;
    MainStoryboard = self.storyboard;
}

+ (instancetype)globalController {
    return MBRootWrapperViewControllerGlobalInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasViewAppeared = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.hasViewAppeared) {
        [self onSplashFinshed];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.hasViewAppeared = YES;
}

#pragma mark - Splash

- (void)onSplashFinshed {
    MBNavigationController *nav = MBNavigationController.newFromStoryboard;
    [self addChildViewController:nav];
    UIView *nv = nav.view;
    nv.autoresizingMask = UIViewAutoresizingFlexibleSize;
    nv.frame = self.view.bounds;
    [self.view insertSubview:nv atIndex:0];
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

