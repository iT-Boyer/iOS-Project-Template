
#import "NSNumber+App.h"

@implementation NSNumber (App)

// Test Case: testNumberDisplay
- (nonnull NSString *)displayString {
    long long count = self.longLongValue;
    if (count < 10000) {
        return [self stringValue];
    }
    else if (count < 1000000) {
        return [NSString stringWithFormat:@"%.1fk", count/1000.0];
    }
    else if (count < 9999500) {
        return [NSString stringWithFormat:@"%.0fk", count/1000.0];
    }
    else if (count < 9999.95 *10000) {
        return [NSString stringWithFormat:@"%.1f万", count/10000.0];
    }
    else {
        return [NSString stringWithFormat:@"%.0f百万", count/1000000.0];
    }
}

- (NSString *)displayStringWithUnitRange:(NSRange *)rangeRef {
    long long count = self.longLongValue;
    NSString *numberPart = nil;
    NSString *unitPart = nil;
    if (count < 10000) {
        numberPart = [NSString stringWithFormat:@"%lld", count];
        unitPart = @"";
    }
    else if (count < 1000000) {
        numberPart = [NSString stringWithFormat:@"%.1f", count/1000.0];
        unitPart = @" k";
    }
    else if (count < 9999500) {
        numberPart = [NSString stringWithFormat:@"%.0f", count/1000.0];
        unitPart = @" k";
    }
    else if (count < 9999.95 *10000) {
        numberPart = [NSString stringWithFormat:@"%.1f", count/10000.0];
        unitPart = @" 万";
    }
    else {
        numberPart = [NSString stringWithFormat:@"%.0f", count/1000000.0];
        unitPart = @" 百万";
    }
    if (rangeRef) {
        *rangeRef = NSMakeRange(numberPart.length, unitPart.length);
    }
    return [NSString stringWithFormat:@"%@%@", numberPart, unitPart];
}

+ (nonnull NSString *)stringFromInt:(int)value {
    return value? [NSString stringWithFormat:@"%d", value] : @"--";
}

+ (nonnull NSString *)stringFromFloat:(double)value {
    return value > 0.1? [NSString stringWithFormat:@"%.1f", value] : @"--";
}

+ (nonnull NSString *)stringFromIntNumber:(nullable NSNumber *)value {
    return [self stringFromInt:[value intValue]];
}

+ (nonnull NSString *)stringFromFloatNumber:(nullable NSNumber *)value {
    return [self stringFromFloat:[value floatValue]];
}

+ (nonnull NSString *)priceStringFromFloat:(double)value addPadding:(BOOL)padding {
    if (padding) {
        return [NSString stringWithFormat:@"%.2f", value];
    }
    else {
        long price100 = round(value * 100);
        if (price100 %100 == 0) {
            return [NSString stringWithFormat:@"%.0f", value];
        }
        else if (price100 %10 == 0) {
            return [NSString stringWithFormat:@"%.1f", value];
        }
        else {
            return [NSString stringWithFormat:@"%.2f", value];
        }
    }
}

@end
