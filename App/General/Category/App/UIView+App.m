
#import "UIView+App.h"

@implementation UIView (App)

- (CGSize)pixelSize {
    UIScreen *s = self.window.screen?: UIScreen.mainScreen;
    return CGSizeScaled(self.size, s.scale);
}

- (BOOL)containsClassInResponderChain:(Class)aClass {
    UIResponder  *rspdr = self;
    do {
        if ([rspdr isMemberOfClass:aClass]) return YES;
    }
    while ((rspdr = rspdr.nextResponder));

    return NO;
}

- (id)firstResponderOfClass:(Class)aClass {
    UIResponder  *rspdr = self;
    do {
        if ([rspdr isMemberOfClass:aClass]) return rspdr;
    }
    while ((rspdr = rspdr.nextResponder));
    
    return nil;
}

+ (instancetype)loadFromNib {
    return [self loadWithNibName:NSStringFromClass([self class])];
}

@end
