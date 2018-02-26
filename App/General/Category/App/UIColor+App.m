
#import "UIColor+App.h"

int const UIColorGlobalTintColorHex = 0x40CCFF;

@implementation UIColor (App)

#define MakeColor(NAME, HEX, ALPHA) \
    + (UIColor *)NAME {\
    static UIColor *sharedInstance = nil; static dispatch_once_t oncePredicate;\
    dispatch_once(&oncePredicate, ^{\
        sharedInstance = [UIColor colorWithRGBHex:HEX alpha:ALPHA];\
    });\
    return sharedInstance; }

#define MakeSolidColor(NAME, HEX) MakeColor(NAME, HEX, 1)

MakeSolidColor(globalTintColor, UIColorGlobalTintColorHex)
+ (UIColor *)globalHighlightedTintColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self globalTintColor] mixedColorWithRatio:.25 color:[UIColor colorWithRGBHex:0xFFFFFF]];
    });
    return sharedInstance;
}
MakeSolidColor(globalDisabledTintColor, 0xCCCCCC)

MakeSolidColor(globalTitleTextColor, 0x535353)
MakeSolidColor(globalBodyTextColor, 0x5e6066)
MakeSolidColor(globalDetialTextColor, 0x9b9b9b)
MakeSolidColor(globalTextColor, 0x535353)
MakeColor(globalPlaceholderTextColor, 0x000019, 0.22)

MakeSolidColor(globalDarkBackgroundColor, 0x222222)
MakeSolidColor(globalLightBackgroundColor, 0xF5F5F5)
MakeSolidColor(globalPageBackgroundColor, 0xF0F4F8)
MakeSolidColor(globalCellSelectionColor, 0xD9D9D9)
MakeColor(globalShadowColor, 0x000000, 0.3)
MakeColor(globalDarkMaskColor, 0x000000, 0.75)

MakeSolidColor(globalImageViewBackgroundColor, 0xEEEEEE)
MakeSolidColor(globalSeparateLineColor, 0xDDDDDD)

MakeSolidColor(globalLightGrayColor, 0xCCCCCC)
MakeSolidColor(globalGrayColor, 0x999999)
MakeSolidColor(globalDarkGrayColor, 0x666666)

MakeSolidColor(globalErrorRead, 0x800000)
MakeSolidColor(globalSleepPurple, 0x6b5fd9)
MakeSolidColor(globalMaleColor, 0x36a2ee)
MakeSolidColor(globalFemaleColor, 0xff6666)

MakeSolidColor(scheduleDisabledThemeColor, 0x40c78d)

MakeSolidColor(scheduleMoodThemeColor, 0x40c78d)
MakeSolidColor(scheduleRuntrackThemeColor, 0x40c78d)
MakeSolidColor(schedulePlankThemeColor, 0x40c78d)
MakeSolidColor(scheduleWeightThemeColor, 0x40c78d)
MakeSolidColor(scheduleHeartBeatThemeColor, 0x40c78d)
MakeSolidColor(scheduleSleepThemeColor, 0x40c78d)
MakeSolidColor(pedometerProgressTintColor, 0x40c78d)
MakeSolidColor(calorieIntakeColor, 0x40c78d)
MakeSolidColor(calorieOverflowColor, 0xff6666)
MakeSolidColor(goalConsultShadowColor, 0x40c78d)

MakeSolidColor(goalCouponRedColor, 0xFF6666)
MakeSolidColor(goalCouponOrgangeColor, 0xFF9219)

#pragma mark -

- (UIColor *)rf_lighterColor {
    return [self mixedColorWithRatio:0.8 color:UIColor.whiteColor];
}

- (UIColor *)rf_darkerColor {
    return [self mixedColorWithRatio:0.8 color:UIColor.blackColor];
}

static UIColor *UIColorFromHexRGBString(NSString *hex) {
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    if (!hex.length) {
        return nil;
    }

    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte = 0, greenByte = 0, blueByte = 0;
    CGFloat alpha = 1.0;

    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&colorCode]; // ignore error

    BOOL hasAlpha = (hex.length == 8);
    if (hasAlpha) {
        redByte = (unsigned char)(colorCode >> 24);
        greenByte = (unsigned char)(colorCode >> 16);
        blueByte = (unsigned char)(colorCode >> 8); // masks off high bits
        alpha = ((float)(colorCode & 0xff)) / 255;
    }
    else {
        redByte = (unsigned char)(colorCode >> 16);
        greenByte = (unsigned char)(colorCode >> 8);
        blueByte = (unsigned char)(colorCode); // masks off high bits
    }

    result = [UIColor colorWithRed: (float)redByte / 0xff green: (float)greenByte/ 0xff blue: (float)blueByte / 0xff alpha:alpha];
    return result;
}

@end
