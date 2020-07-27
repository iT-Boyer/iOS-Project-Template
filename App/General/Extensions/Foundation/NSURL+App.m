
#import "NSURL+App.h"

@implementation NSURL (App)

- (BOOL)isHTTPURL {
    NSString *sc = self.scheme.lowercaseString;
    if ([sc isEqualToString:@"http"]
        || [sc isEqualToString:@"https"]) {
        return YES;
    }
    return NO;
}

@end
