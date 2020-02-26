
#import "UIColor+App.h"
#import "Common.h"

@implementation UIColor (App)

+ (UIColor *)globalPlaceholderTextColor {
    return self.systemPlaceholderColor;
}

#pragma mark -

- (UIColor *)rf_lighterColor {
    return [self mixedColorWithRatio:0.8 color:UIColor.whiteColor];
}

- (UIColor *)rf_darkerColor {
    return [self mixedColorWithRatio:0.8 color:UIColor.blackColor];
}

@end
