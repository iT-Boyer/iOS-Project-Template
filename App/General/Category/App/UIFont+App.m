
#import "UIFont+App.h"

@implementation UIFont (App)

+ (nonnull UIFont *)applicationFontOfSize:(CGFloat)fontSize {
    return [self systemFontOfSize:fontSize];
}

+ (nonnull UIFont *)globalContentFont {
    static UIFont *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [self applicationFontOfSize:15];
    });
    return sharedInstance;
}

@end
