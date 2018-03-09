
#import "ZYLayoutButton.h"
#import "MBAnalytics.h"
#import "MBNavigationController.h"

@interface RFButton ()
- (void)onTouchUpInside;
@end

@interface ZYLayoutButton ()
@property (nonatomic) BOOL touchDownEffectApplied;
@end

@implementation ZYLayoutButton

- (void)onInit {
    [super onInit];

    [self addTarget:self action:@selector(_touchDownEffect) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(_touchUpEffect) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(_touchUpEffect) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(_touchUpEffect) forControlEvents:UIControlEventTouchCancel];

    if (!self.scale) {
        self.scale = 1.1;
    }

    if (!self.touchDuration) {
        self.touchDuration = 0.2;
    }

    if (!self.releaseDuration) {
        self.releaseDuration = 0.3;
    }
}

- (void)_touchDownEffect {
    if (self.touchEffectDisabled) return;
    if (self.touchDownEffectApplied) return;
    self.touchDownEffectApplied = YES;
    [self touchDownEffect];
}

- (void)_touchUpEffect {
    if (!self.touchDownEffectApplied) return;
    [self touchUpEffect];
    self.touchDownEffectApplied = NO;
}

- (void)touchDownEffect {
    [UIView animateWithDuration:self.touchDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.layer.transform = CATransform3DMakeScale(self.scale, self.scale, 1);
    } completion:nil];
}

- (void)touchUpEffect {
    [UIView animateWithDuration:self.releaseDuration delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.layer.transform = CATransform3DIdentity;
    } completion:nil];
}

- (void)onTouchUpInside {
    [super onTouchUpInside];
    [self.viewController MBAnalyticsCustomEventWithSender:self attributes:nil];
    // @TODO
//    if (self.jumpURL.length) {
//        APNavigationControllerJumpWithURL([NSURL URLWithString:self.jumpURL]);
//    }
}

@end
