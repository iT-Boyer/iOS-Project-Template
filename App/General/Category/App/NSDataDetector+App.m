
#import "NSDataDetector+App.h"

@implementation NSDataDetector (App)

+ (NSDataDetector *)globalLinkDetector {
    static NSDataDetector *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    });
    return sharedInstance;
}

@end
