
#import "ZYModalPresentSegue.h"
#import "UIView+RFAnimate.h"

@implementation ZYModalPresentSegue

- (void)RFPerform {
    UIViewController *root = [UIViewController rootViewControllerWhichCanPresentModalViewController];
    ZYModalPresentContainer *container = [ZYModalPresentContainer newFromStoryboard];
    [root addChildViewController:container];
    [root.view addSubview:container.view resizeOption:RFViewResizeOptionFill];

    UIViewController *dest = self.destinationViewController;
    [container addChildViewController:dest];
    [container.containedViewHolder addSubview:dest.view resizeOption:RFViewResizeOptionFill];
    dest.view.autoresizingMask = UIViewAutoresizingFlexibleSize;

    [dest setNeedsStatusBarAppearanceUpdate];
    [container setViewHidden:NO animated:YES completion:nil];
}

@end

@interface ZYModalPresentContainer ()
@property (nonatomic) CGFloat translationStartOffset;
@end

@implementation ZYModalPresentContainer

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];

        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (IBAction)onPanInView:(UIPanGestureRecognizer *)gestureRecognizer {
    static CGPoint orgCenter;
    UIView *piece = [gestureRecognizer view];

//    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];

    CGFloat translation = [gestureRecognizer translationInView:piece.superview].y;
    CGFloat offset = translation - self.translationStartOffset;

    CGFloat velocity = [gestureRecognizer velocityInView:piece.superview].y;
    _dout_float(velocity)
    _dout_float(offset)

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.translationStartOffset = translation;
            orgCenter = piece.center;
        }
        case UIGestureRecognizerStateChanged: {
            if (offset < 0) {
                offset = 0;
            }
            [piece setCenter:CGPointMake(orgCenter.x, orgCenter.y + offset)];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (offset + velocity > 200) {
                [self dismiss:self];
            }
            else {
                [UIView animateWithDuration:0.2 animations:^{
                    piece.center = orgCenter;
                }];
            }
            break;
        }

        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    @weakify(self);
    [self setViewHidden:YES animated:NO completion:^{
        @strongify(self);
        [self removeFromParentViewControllerAndView];
    }];
}

- (IBAction)dismiss:(id)sender {
    @weakify(self);
    [self setViewHidden:YES animated:YES completion:^{
        @strongify(self);
        [self removeFromParentViewControllerAndView];
    }];
}

- (IBAction)dismissModelPresent:(UIStoryboardSegue *)sender {
    [self dismiss:sender];
}

- (void)setViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion {
    __weak UIView *mask = self.maskView;
    __weak UIView *menu = self.containedViewHolder;
    CGFloat height = menu.height;

    self.hidden = hidden;
    [self setNeedsStatusBarAppearanceUpdate];

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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.hidden) {
        NSArray *vcs = self.parentViewController.childViewControllers;
        for (id vc in vcs.reverseObjectEnumerator) {
            if (vc != self) {
                return vc;
            }
        }
    }
    return self.childViewControllers.lastObject;
}

@end
