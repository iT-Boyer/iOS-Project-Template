
#import "NSString+App.h"

@implementation NSString (ZYApp)

- (BOOL)isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPhoneNumber {
    NSString * MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

//! REF: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/TextLayout/Tasks/CountLines.html
- (NSUInteger)rf_numberOfHardLineBreaks {
    NSUInteger numberOfLines, index, stringLength = self.length;
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        index = NSMaxRange([self lineRangeForRange:NSMakeRange(index, 0)]);
    }
    return numberOfLines;
}

- (long)longValue {
    return [self integerValue];
}

- (long long)unsignedLongLongValue {
    return [self integerValue];
}

+ (BOOL)isNewVersion:(NSString *)latestVersion currentversion:(NSString *)currentversion {
    NSParameterAssert(currentversion);
    if (!latestVersion) return NO;
    return [currentversion compare:latestVersion options:NSNumericSearch] == NSOrderedAscending;
}

@end
