
#import "ZYTemplateImageView.h"

@interface ZYTemplateImageView ()
@end

@implementation ZYTemplateImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self tintColorDidChange];
}

- (void)setImage:(UIImage *)image {
    if (self.ZYTemplateImageView_shouldRenderAsTemplate) {
        if (image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }
    [super setImage:image];
}

- (void)setHighlightedImage:(UIImage *)image {
    if (self.ZYTemplateImageView_shouldRenderAsTemplate) {
        if (image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }
    [super setHighlightedImage:image];
}

- (void)tintColorDidChange {
    if (!self.ZYTemplateImageView_shouldRenderAsTemplate) {
        [self ZYTemplateImageView_restoreImageRenderingModeIfNeeded];
    }
    else {
        UIImage *image = self.image;
        if (image
            && image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
            self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        image = self.highlightedImage;
        if (image
            && image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
            self.highlightedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }
    [super tintColorDidChange];
}

- (BOOL)ZYTemplateImageView_shouldRenderAsTemplate {
    return ![self.ignoredTintColor isEqual:self.tintColor];
}

- (void)ZYTemplateImageView_restoreImageRenderingModeIfNeeded {
    UIImage *image = self.image;
    if (image
        && image.renderingMode == UIImageRenderingModeAlwaysTemplate) {
        self.image = [image imageWithRenderingMode:UIImageRenderingModeAutomatic];
    }
    image = self.highlightedImage;
    if (image
        && image.renderingMode == UIImageRenderingModeAlwaysTemplate) {
        self.highlightedImage = [image imageWithRenderingMode:UIImageRenderingModeAutomatic];
    }
}

@end
