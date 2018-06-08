
#import "UIButton+App.h"

@implementation UIButton (App)

- (nullable NSString *)text {
    return self.currentTitle;
}

- (void)setText:(nullable NSString *)text {
    self.titleLabel.text = text;
    [self setTitle:text forState:UIControlStateNormal];
}

@end
