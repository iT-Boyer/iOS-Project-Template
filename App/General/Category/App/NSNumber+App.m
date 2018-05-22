
#import "NSNumber+App.h"

@implementation NSNumber (App)

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
