
#import "UIViewController+App.h"
#import <MBAppKit/NSObject+MBAppKit.h>

@implementation UIViewController (App)

+ (nonnull instancetype)newFromStoryboard {
    NSString *storyboardName = self.storyboardName;
    if (!storyboardName.length) {
        NSAssert(NO, @"storyboardName not set.");
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    NSString *iden = self.className;
    return [sb instantiateViewControllerWithIdentifier:iden];
}

+ (nullable NSString *)storyboardName {
    return nil;
}

- (void)RFPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(BOOL presented))completion {
    UIViewController *navVisible = self.navigationController.visibleViewController;
    BOOL isNavVisible = NO;
    UIViewController *vc = self;
    while (vc) {
        if (vc == navVisible) {
            isNavVisible = YES;
            break;
        }
        vc = vc.parentViewController;
    }
    if (!self.isViewAppeared
        || !self.navigationController
        || !isNavVisible) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    [self.navigationController presentViewController:viewControllerToPresent animated:flag completion:^{
        if (completion) {
            completion(YES);
        }
    }];
}

@end
