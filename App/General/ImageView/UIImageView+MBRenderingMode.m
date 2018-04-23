
#import "UIImageView+MBRenderingMode.h"

@implementation UIImageView (MBRenderingMode)

- (BOOL)renderingAsTemplate {
    RFAssert(false, @"这是个伪属性，只在 set 时更新一下图片");
    return NO;
}

- (void)setRenderingAsTemplate:(BOOL)renderingAsTemplate {
    if (!renderingAsTemplate) return;

    UIImage *image = self.image;
    if (image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
        self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else {
        // iOS 8, iOS 9 都需要重设一下
        // REF: http://stackoverflow.com/a/30741478/945906
        if (!RF_iOS8Before) {
            UIColor *tintColor = self.tintColor;
            self.tintColor = nil;
            self.tintColor = tintColor;
        }
    }
}

@end
