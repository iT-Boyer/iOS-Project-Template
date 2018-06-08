
#import "RFMessage+App.h"
#import "UIKit+App.h"

@implementation RFNetworkActivityIndicatorMessage (App)

- (NSString *)displayString {
    if (self.title.length && self.message.length) {
        if ([self.title isEqualToString:@"不能完成请求"]) {
            return self.message;
        }
        return [NSString stringWithFormat:@"%@: %@", self.title, self.message];
    }
    else if (self.title.length) {
        return self.title;
    }
    else if (self.message.length) {
        return self.message;
    }
    return nil;
}

- (NSTimeInterval)displayDuration {
    if (self.displayTimeInterval) return self.displayTimeInterval;
    NSTimeInterval d = self.displayString.length * 0.15 + 0.5;
    limitedDouble(&d, 2, 10);
    return d;
}

@end
