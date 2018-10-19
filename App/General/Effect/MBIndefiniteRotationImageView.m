
#import "MBIndefiniteRotationImageView.h"
#import "CALayer+MBAnimationPersistence.h"

@implementation MBIndefiniteRotationImageView

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        [self.layer MBResumePersistentAnimationsIfNeeded];
        [self addAnimationIfNeeded];
    }
}

- (void)setStopAnimation:(BOOL)stopAnimation {
    _stopAnimation = stopAnimation;
    if (stopAnimation) {
        [self.layer removeAnimationForKey:@"rotate"];
    }
    else {
        if (self.window) {
            [self addAnimationIfNeeded];
        }
    }
}

- (void)addAnimationIfNeeded {
    if (self.stopAnimation || [self.layer.animationKeys containsObject:@"rotate"]) return;
    
    NSTimeInterval animationDuration = self.rotateDuration > 0 ? self.rotateDuration : 1;
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = (id) 0;
    animation.toValue = @(M_PI*2);
    animation.duration = animationDuration;
    animation.timingFunction = linearCurve;
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    [self.layer addAnimation:animation forKey:@"rotate"];
    [self.layer MBPersistCurrentAnimations];
}

@end
