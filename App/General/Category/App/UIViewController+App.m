
#import "UIViewController+App.h"

@implementation UIViewController (App)

+ (nonnull instancetype)newFromStoryboard {
    UIStoryboard *sb = self.storyboardName? [UIStoryboard storyboardWithName:self.storyboardName bundle:nil] : MainStoryboard;
    @try {
        return [sb instantiateViewControllerWithIdentifierUsingClass:[self class]];
    }
    @catch (NSException *exception) {
        dout_error(@"Cannot find %@ in %@ storyboard", self, self.storyboardName?: @"Main");
    }
}

+ (nullable NSString *)storyboardName {
    return nil;
}

@end
