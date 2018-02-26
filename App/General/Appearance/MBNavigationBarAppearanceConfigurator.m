
#import "MBNavigationBarAppearanceConfigurator.h"

#import "RFDrawImage.h"

@implementation MBNavigationBarAppearanceConfigurator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.barColor = [UIColor whiteColor];
        self.removeBarShadow = YES;

        self.titleColor = [UIColor blackColor];
        self.clearTitleShadow = YES;

        self.itemTitleColor = [UIColor globalTintColor];
        self.itemTitleHighlightedColor = [UIColor globalHighlightedTintColor];
        self.itemTitleDisabledColor = [UIColor globalDisabledTintColor];
        self.clearItemBackground = YES;
    }
    return self;
}

- (void)applay {
    id navigationBarAppearance = self.appearance?: [UINavigationBar appearance];
    id itemAppearance = self.barButtonItemAppearance?: [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];

    // 基础颜色设置
    [navigationBarAppearance setBarTintColor:self.barColor];

    // 背景设置
    if (self.backgroundImage) {
        [navigationBarAppearance setBackgroundImage:self.backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    if (self.removeBarShadow) {
        [navigationBarAppearance setShadowImage:UIImage.new];
    }

    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (self.clearTitleShadow) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textAttributes[UITextAttributeTextShadowColor] = [UIColor clearColor];
#pragma clang diagnostic pop
    }

    // 标题设置
    textAttributes[NSForegroundColorAttributeName] = self.titleColor;

    NSMutableDictionary *titleTextAttributes = [textAttributes mutableCopy];
    [titleTextAttributes addEntriesFromDictionary:self.titleTextAttributes];
    [navigationBarAppearance setTitleTextAttributes:titleTextAttributes];

    // 按钮文字设置
    textAttributes[NSForegroundColorAttributeName] = self.itemTitleColor;

    if (self.itemTitleFontSize) {
        textAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:self.itemTitleFontSize];
    }
	[itemAppearance setTitleTextAttributes:textAttributes.copy forState:UIControlStateNormal];

    textAttributes[NSForegroundColorAttributeName] = self.itemTitleHighlightedColor;
    [itemAppearance setTitleTextAttributes:textAttributes.copy forState:UIControlStateHighlighted];

    textAttributes[NSForegroundColorAttributeName] = self.itemTitleDisabledColor;
    [itemAppearance setTitleTextAttributes:textAttributes.copy forState:UIControlStateDisabled];

    UIImage *blankButtonBackgroundImage = [RFDrawImage imageWithSizeColor:CGSizeMake(10, 30) fillColor:[UIColor clearColor]];
    // 普通按钮背景
    if (self.clearItemBackground) {
        [itemAppearance setBackgroundImage:blankButtonBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }

    // 返回按钮背景
    if (self.backButtonIcon) {
        UIImage *backImage = self.backButtonIcon;
        if (UIEdgeInsetsEqualToEdgeInsets(self.backButtonIcon.capInsets, UIEdgeInsetsZero) ) {
            // 需要转
            CGSize imageSize = backImage.size;
            backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(imageSize.height, imageSize.width, 0, 1)];
            if ([self.backButtonIcon respondsToSelector:@selector(renderingMode)]) {
                backImage = [backImage imageWithRenderingMode:self.backButtonIcon.renderingMode];
            }
        }
        [navigationBarAppearance setBackIndicatorImage:backImage];
        [navigationBarAppearance setBackIndicatorTransitionMaskImage:backImage];

        // 把标题移出屏幕
        [itemAppearance setBackButtonTitlePositionAdjustment:UIOffsetMake(-9999, 0) forBarMetrics:UIBarMetricsDefault];
        [itemAppearance setBackButtonTitlePositionAdjustment:UIOffsetMake(-9999, 0) forBarMetrics:UIBarMetricsLandscapePhone];
    }
}

@end
