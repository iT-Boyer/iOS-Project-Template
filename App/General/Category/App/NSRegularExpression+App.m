
#import "NSRegularExpression+App.h"

@implementation NSRegularExpression (App)

+ (nonnull NSRegularExpression *)globalMetionRegularExpression {
    static NSRegularExpression *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [NSRegularExpression regularExpressionWithPattern:@"(@[\\S]+)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return sharedInstance;
}

+ (nonnull NSRegularExpression *)CJKCharRegularExpression {
    static NSRegularExpression *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [NSRegularExpression regularExpressionWithPattern:@"\\p{InCJK}" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return sharedInstance;
}

@end
