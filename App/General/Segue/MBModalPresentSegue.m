
#import "MBModalPresentSegue.h"
#import "MBNavigationController.h"
#import "UIView+RFAnimate.h"
#import "UIViewController+RFKit.h"

@implementation MBModalPresentSegue

- (void)RFPerform {
    UIViewController *parent = [UIViewController rootViewControllerWhichCanPresentModalViewController];
    MBModalPresentViewController *vc = self.destinationViewController;
    if (![vc isKindOfClass:[MBModalPresentViewController class]]) {
        RFAssert(false, @"%@ is not a MBModalPresentViewController.", vc);
        return;
    }

    [vc presentFromViewController:parent animated:YES completion:nil];
}

@end

@implementation MBModalPresentPushSegue

- (void)perform {
    [AppNavigationController() pushViewController:self.destinationViewController animated:YES];
}

@end

@implementation MBModalPresentViewController

- (void)presentFromViewController:(UIViewController *)parentViewController animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!parentViewController) {
        parentViewController = [UIViewController rootViewControllerWhichCanPresentModalViewController];
    }

    UIView *dest = self.view;
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:dest resizeOption:RFViewResizeOptionFill];

    // 解决 iPad 上动画弹出时 frame 不正确
    dest.hidden = YES;
    dispatch_after_seconds(0.05, ^{
        dest.hidden = NO;
        [(id<MBModalPresentSegueDelegate>)self setViewHidden:NO animated:YES completion:completion];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self dismissAnimated:YES completion:nil];
}

- (IBAction)dismiss:(UIButton *)sender {
    if ([sender respondsToSelector:@selector(setEnabled:)]) {
        sender.enabled = NO;
    }
    [self dismissAnimated:YES completion:nil];
}

- (void)dismissAnimated:(BOOL)flag completion:(void (^)(void))completion {
    @weakify(self);
    [self setViewHidden:YES animated:YES completion:^{
        @strongify(self);
        [self removeFromParentViewControllerAndView];
        if (completion) {
            completion();
        }
    }];
}

- (void)setViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion {
    __weak UIView *mask = self.maskView;
    __weak UIView *menu = self.containerView;
    CGFloat height = menu.height;

    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animated:animated beforeAnimations:^{
        mask.alpha = hidden? 1 : 0;
        menu.bottomMargin = hidden? 0 : -height;
    } animations:^{
        mask.alpha = hidden? 0 : 1;
        menu.bottomMargin = hidden? -height : 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

@end

@implementation UIViewController (MBOverCurrentContextModalPresenting)

- (void)MBOverCurrentContextPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    UIViewController *presentingVC = self;

    if (RF_iOS8Before) {
        UIViewController *root = presentingVC;
        while (root.parentViewController) {
            root = root.parentViewController;
        }

        void (^action)(void) = ^(void){
            UIModalPresentationStyle orginalStyle = root.modalPresentationStyle;
            if (orginalStyle != UIModalPresentationCurrentContext) {
                root.modalPresentationStyle = UIModalPresentationCurrentContext;
            }
            [presentingVC presentViewController:viewControllerToPresent animated:NO completion:completion];
            if (orginalStyle != UIModalPresentationCurrentContext) {
                root.modalPresentationStyle = orginalStyle;
            }
        };

        if (flag) {
            [presentingVC presentViewController:viewControllerToPresent animated:flag completion:^{
                [viewControllerToPresent dismissViewControllerAnimated:NO completion:action];
            }];
        }
        else {
            action();
        }
        return;
    }

    UIModalPresentationStyle orginalStyle = viewControllerToPresent.modalPresentationStyle;
    if (orginalStyle != UIModalPresentationOverCurrentContext) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [presentingVC presentViewController:viewControllerToPresent animated:flag completion:completion];
    if (orginalStyle != UIModalPresentationOverCurrentContext) {
        viewControllerToPresent.modalPresentationStyle = orginalStyle;
    }
}

@end

@implementation MBOverCurrentContextModalPresentSegue

- (void)RFPerform {
    [self noticeDelegateWillPerform];
    [self.sourceViewController MBOverCurrentContextPresentViewController:self.destinationViewController animated:YES completion:^{
        [self noticeDelegateDidPerformed];
    }];
}

@end

@implementation TestVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    doutwork()
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    doutwork()
}

@end
