
#import "UIViewController+App.h"
#import <MBAppKit/NSObject+MBAppKit.h>

@implementation UIViewController (App)

+ (nonnull instancetype)newFromStoryboard {
    UIStoryboard *sb = self.storyboardName? [UIStoryboard storyboardWithName:self.storyboardName bundle:nil] : MainStoryboard;
    NSString *iden = self.className;
    @try {
        return [sb instantiateViewControllerWithIdentifier:iden];
    }
    @catch (NSException *exception) {
        dout_error(@"Cannot find %@ in %@ storyboard", iden, self.storyboardName?: @"Main");
    }
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
