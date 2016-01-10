
#import "UIViewController+APIControl.h"
#import <objc/runtime.h>

static char UIViewController_APIControl_CateogryProperty;

@implementation UIViewController (APIControl)

- (NSString *)APIGroupIdentifier {
    id value = objc_getAssociatedObject(self, &UIViewController_APIControl_CateogryProperty);
    if (value) return value;
    return NSStringFromClass(self.class);
}

- (void)setAPIGroupIdentifier:(NSString *)APIGroupIdentifier {
    objc_setAssociatedObject(self, &UIViewController_APIControl_CateogryProperty, APIGroupIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
