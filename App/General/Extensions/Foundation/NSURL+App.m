
#import "NSURL+App.h"

@implementation NSURL (App)

- (nonnull NSURL *)URLByResolvingApplicationDirectoryChange {
    if (!self.isFileURL) return self;

    NSString *pathHome = NSHomeDirectory();
    NSString *pathThis = self.path;
    if ([pathThis hasPrefix:pathHome]) {
        return self;
    }

    NSArray<NSString *> *cpHome = pathHome.pathComponents;
    NSMutableArray<NSString *> *cpThis = pathThis.pathComponents.mutableCopy;
    if (cpThis.count < cpHome.count) {
        return self;
    }

    NSInteger i = 0;
    for (i = 0; i < cpHome.count - 2; i++) {
        NSString *hp = cpHome[i];
        NSString *tp = cpThis[i];
        if (![hp isEqualToString:tp]) {
            return self;
        }
    }
    i++;
    NSString *hp = cpHome[i];
    NSString *tp = cpThis[i];
    if (hp.length != tp.length) {
        return self;
    }
    [cpThis replaceObjectAtIndex:i withObject:hp];
    NSString *resolvedPath = [NSString pathWithComponents:cpThis];
    return [NSURL.alloc initFileURLWithPath:resolvedPath];
}

- (BOOL)isHTTPURL {
    NSString *sc = self.scheme.lowercaseString;
    if ([sc isEqualToString:@"http"]
        || [sc isEqualToString:@"https"]) {
        return YES;
    }
    return NO;
}

@end
