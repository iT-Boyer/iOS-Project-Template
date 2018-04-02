
#import "UIViewController+RFInterfaceOrientation.h"
#import <objc/runtime.h>

@implementation UIViewController (RFInterfaceOrientation)

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

@end
