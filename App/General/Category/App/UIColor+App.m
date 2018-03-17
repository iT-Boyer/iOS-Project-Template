
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
MakeColor(globalPlaceholderTextColor, 0x000019, 0.22)

MakeSolidColor(globalDarkBackgroundColor, 0x222222)
MakeSolidColor(globalLightBackgroundColor, 0xF5F5F5)
MakeSolidColor(globalPageBackgroundColor, 0xF0F4F8)
MakeSolidColor(globalCellSelectionColor, 0xD9D9D9)
MakeSolidColor(globalErrorRead, 0x800000)

#pragma mark -

- (UIColor *)rf_lighterColor {
    return [self mixedColorWithRatio:0.8 color:UIColor.whiteColor];
}

- (UIColor *)rf_darkerColor {
    return [self mixedColorWithRatio:0.8 color:UIColor.blackColor];
}

@end
