
#import "MBSearchViewController.h"
#import "UIViewController+RFDNavigationAppearance.h"
#import "RFAnimationTransitioning.h"
#import "UISearchBar+RFKit.h"


@interface MBSearchTransitioning : RFAnimationTransitioning
@end

@interface MBSearchViewController ()
@end

@implementation MBSearchViewController
RFUIInterfaceOrientationSupportDefault

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.RFPrefersNavigationBarHidden = YES;
    self.RFPrefersLightContentBarStyle = NO;
    // 在 initWithCoder: 前设置默认属性，以便外面的设置不会被覆盖
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad {
    self.hasViewAppeared = NO;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.searchBar.showsCancelButton = YES;

    if (self.focusSearchBarWhenAppear) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_after_seconds(0, ^{
        // 一进来键盘没出来的话，按钮禁用
        self.searchBar.cancelButton.enabled = YES;
        
        UILabel *cancelLabel = self.searchBar.cancelButton.titleLabel;
        cancelLabel.font = [cancelLabel.font fontWithSize:15];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.hasViewAppeared) {
        [self setupAfterViewAppear];
    }
    self.hasViewAppeared = YES;
}

- (void)setupAfterViewAppear {
    // nothing
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)RFTransitioningStyle {
    return MBSearchTransitioning.className;
}

@end

@implementation MBSearchTransitioning

- (NSTimeInterval)duration {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {

    UIView *containerView = transitionContext.containerView;
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    BOOL reverse = self.reverse;

    MBSearchViewController *searchViewController = (id)(reverse? fromVC : toVC);
    UIView *container = searchViewController.container;

    // Navigation bar hidden may change between transition.
    // Let initial frame bigger can avoid user see window background.
    toView.frame = CGRectContainsRect(toFrame, fromFrame)? toFrame : fromFrame;

    if (reverse) {
        [containerView insertSubview:toView belowSubview:fromView];
    }
    else {
        [containerView insertSubview:toView aboveSubview:fromView];
    }

    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animated:YES beforeAnimations:^{
        if (reverse) {
        }
        else {
            container.y = toView.height/2;
            toView.alpha = 0;
        }
    } animations:^{
        if (reverse) {
            fromView.alpha = 0;
        }
        else {
            container.bottomMargin = 0;
            toView.alpha = 1;
        }
        toView.frame = toFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
