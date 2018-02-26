
#import "ZYNavigationTabControl.h"
#import "UIView+RFAnimate.h"

@interface ZYNavigationTabControl ()
@end

@implementation ZYNavigationTabControl

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.indicatingImageView sentToBack];
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    [self updateMask];
}

- (void)updateIndicatingImage {
    self.indicatingImageView.image = [UIImage imageNamed:@"navigation_tab_selection"];
    self.indicatingImageView.height = 30;
    self.indicatingImageView.y = (self.height - 30)/2;
}

- (void)updateIndicatingImageViewFrame {
    if (!self.indicatorEnabled) return;
    UIButton *button = (id)self.selectedControl;
    if (![button isKindOfClass:[UIButton class]]) return;

    UIImageView *indicator = self.indicatingImageView;
    CGFloat indicatorWidth = self.width - 3;
    indicator.width = indicatorWidth/self.controls.count;
    CGPoint center = indicator.center;
    center.x = button.center.x;

    indicator.center = center;
}

- (void)updateMask {
    CAShapeLayer *maskLayer = (id)self.layer.mask;
    if (!maskLayer) {
        maskLayer = [CAShapeLayer layer];
        self.layer.mask = maskLayer;
    }

    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x, (bounds.size.height - 29)/2, bounds.size.width, 29);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:8];
    maskLayer.path = bezierPath.CGPath;
    maskLayer.frame = self.layer.bounds;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self updateMask];
}


@end
