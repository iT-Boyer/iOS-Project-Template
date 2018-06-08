
#import "UIAlertController+App.h"
#import <UIViewController+RFKit.h>

@implementation UIAlertController (App)

- (void)addCancelActionWithHandler:(void (^ __nullable)(UIAlertAction *action))handler {
    [self addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"取消") style:UIAlertActionStyleCancel handler:handler]];
}

- (void)showWithController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    if (!viewController) {
        viewController = UIViewController.rootViewControllerWhichCanPresentModalViewController;
    }
    [viewController presentViewController:self animated:flag completion:completion];
}

@end
