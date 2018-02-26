
#import "MBButton.h"

@interface MBButton ()
@property (readwrite) BOOL appearanceSetupDone;
@end

@implementation MBButton
RFInitializingRootForUIView

- (void)onInit {
}

- (void)afterInit {
    [self addTarget:self action:@selector(onButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self _setupAppearance];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _setupAppearance];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    [self _setupAppearance];
}

- (void)_setupAppearance {
    if (self.appearanceSetupDone) return;
    self.appearanceSetupDone = YES;
    if (!self.skipAppearanceSetup) {
        [self setupAppearance];
    }
}

- (void)onButtonTapped {
    // For overwrite
}

- (void)setupAppearance {
    // For overwrite
}

- (void)setSelected:(BOOL)selected {
    // Fix iOS 7 文字变化时尺寸不自动更新
    if (selected != self.selected) {
        [self invalidateIntrinsicContentSize];
    }
    [super setSelected:selected];
}

- (void)setEnabled:(BOOL)enabled {
    // Fix iOS 7 文字变化时尺寸不自动更新
    if (enabled != self.enabled) {
        [self invalidateIntrinsicContentSize];
    }
    [super setEnabled:enabled];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint origin = self.touchHitTestExpandInsets.origin;
    CGSize size = self.touchHitTestExpandInsets.size;
    UIEdgeInsets reversedInsets = (UIEdgeInsets){ origin.x, origin.y, size.width, size.height };
    reversedInsets.top = -reversedInsets.top;
    reversedInsets.left = -reversedInsets.left;
    reversedInsets.bottom = -reversedInsets.bottom;
    reversedInsets.right = -reversedInsets.right;
    CGRect expandRect = UIEdgeInsetsInsetRect(self.bounds, reversedInsets);
    return CGRectContainsPoint(expandRect, point);
}

@end


@implementation MBControlTouchExpandContainerView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIControl *c in self.controls) {
        if ([c pointInside:[self convertPoint:point toView:c] withEvent:event]) {
            return YES;
        }
    }
    return [super pointInside:point withEvent:event];
}

@end

@implementation MBItemButton

@end
