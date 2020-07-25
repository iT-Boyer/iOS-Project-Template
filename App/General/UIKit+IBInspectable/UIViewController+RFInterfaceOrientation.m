
#import "UIViewController+RFInterfaceOrientation.h"
#import <RFAlpha/RFSwizzle.h>
#import <objc/runtime.h>

@implementation UIViewController (RFInterfaceOrientation)

+ (void)load {
    // @bug(iOS 13): 之前的系统不需要 swizzle，category 里重载就行
    RFSwizzleInstanceMethod(UIViewController.class, @selector(supportedInterfaceOrientations), @selector(_rf_supportedInterfaceOrientations));
}

static char _rf_category_RFInterfaceOrientation;

- (NSInteger)RFInterfaceOrientation {
    return [objc_getAssociatedObject(self, &_rf_category_RFInterfaceOrientation) integerValue];
}
- (void)setRFInterfaceOrientation:(NSInteger)RFInterfaceOrientation {
    objc_setAssociatedObject(self, &_rf_category_RFInterfaceOrientation, @(RFInterfaceOrientation), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)RFInterfaceOrientationSet {
    return objc_getAssociatedObject(self, &_rf_category_RFInterfaceOrientation) != nil;
}

- (UIInterfaceOrientationMask)_rf_supportedInterfaceOrientations {
    if (!self.RFInterfaceOrientationSet) {
        return self._rf_supportedInterfaceOrientations;
    }
    NSInteger o = self.RFInterfaceOrientation;
    if (o == 1) {
        return UIInterfaceOrientationMaskLandscape;
    }
    else if (o == 2) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
