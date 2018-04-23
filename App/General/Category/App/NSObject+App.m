
#import "NSObject+App.h"

@implementation NSObject (App)

+ (NSString *)className {
    NSString *className = NSStringFromClass(self);
    if ([className rangeOfString:@"."].location != NSNotFound) {
        // Swift class name contains module name
        return [className componentsSeparatedByString:@"."].lastObject;
    }
    return className;
}

- (NSString *)className {
    return NSStringFromClass(self.class);
}

@end

BOOL MBObjectIsEquail(id __nullable a, id __nullable b) {
    if (!a && !b) {
        // 都空
        return YES;
    }
    if (!a || !b) {
        // 只有一个是空
        return NO;
    }
    return [a isEqual:b];
}
