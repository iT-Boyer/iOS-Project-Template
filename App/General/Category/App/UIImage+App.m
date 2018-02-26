
#import "UIImage+App.h"

@implementation UIImage (App)

+ (nonnull UIImage *)animatedIndicatorWhite {
    static UIImage *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [UIImage animatedImageNamed:@"load1_" duration:.7];
    }
    return sharedInstance;
}

+ (nonnull UIImage *)animatedIndicator {
    static UIImage *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [UIImage animatedImageNamed:@"load2_" duration:.7];
    }
    return sharedInstance;
}

@end
