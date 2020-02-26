
#import "UIView+App.h"

@implementation UIView (App)

- (id)firstResponderOfClass:(Class)aClass {
    UIResponder *rspdr = self;
    do {
        if ([rspdr isMemberOfClass:aClass]) return rspdr;
    }
    while ((rspdr = rspdr.nextResponder));
    
    return nil;
}

@end
