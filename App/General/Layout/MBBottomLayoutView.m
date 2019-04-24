
#import "MBBottomLayoutView.h"

@interface MBBottomLayoutView ()
@property (nullable) NSLayoutConstraint *_bottomConstraint;
@property (nullable) NSLayoutConstraint *_leftConstraint;
@property (nullable) NSLayoutConstraint *_rightConstraint;
@property (nonatomic) BOOL _MBBottomLayoutView_isClipping;
@end

@implementation MBBottomLayoutView
RFInitializingRootForUIView
    
- (void)onInit {
    self.clipsToBounds = YES;
    _clippingCornerRadius = CGFLOAT_MAX;
    _clippingMargin = 15;
}

- (void)afterInit {
    // Nothing
}

- (void)updateConstraints {
    [super updateConstraints];
    if (@available(iOS 11.0, *)) {
        _douto(self.safeAreaLayoutGuide);
    }
    else {
        return;
    }
    
    UILayoutGuide *possibleSafeLayoutGuide = nil;
    for (NSLayoutConstraint *c in self.superview.constraints) {
        if (c.firstItem != self && c.secondItem != self) continue;
        UILayoutGuide *lg = c.firstItem == self ? c.secondItem : c.firstItem;
        if (![lg isKindOfClass:UILayoutGuide.class]) continue;
        NSLayoutAttribute viewAttribute = c.firstItem == self ? c.firstAttribute : c.secondAttribute;

        switch (viewAttribute) {
            case NSLayoutAttributeLeading:
                self._leftConstraint = c;
                break;
            case NSLayoutAttributeTrailing:
                self._rightConstraint = c;
                break;
            case NSLayoutAttributeBottom:
                self._bottomConstraint = c;
                possibleSafeLayoutGuide = lg;
                break;
            default:
                break;
        }
    }
    self._MBBottomLayoutView_isClipping = CGRectGetMaxY(possibleSafeLayoutGuide.layoutFrame) != CGRectGetHeight(possibleSafeLayoutGuide.owningView.bounds);
}

- (void)set_MBBottomLayoutView_isClipping:(BOOL)isClipping {
    if (__MBBottomLayoutView_isClipping == isClipping) return;
    __MBBottomLayoutView_isClipping = isClipping;
    CGFloat cr = 0;
    if (isClipping) {
        cr = self.bounds.size.height / 2;
        if (self.clippingCornerRadius < cr && self.clippingCornerRadius >= 0) {
            cr = self.clippingCornerRadius;
        }
    }
    self.layer.cornerRadius = cr;
    
    CGFloat margin = isClipping ? self.clippingMargin : 0;
    self._leftConstraint.constant = margin;
    self._rightConstraint.constant = margin;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    self.heightConstraint.active = !hidden;
    [self invalidateIntrinsicContentSize];
    if (!self._MBBottomLayoutView_isClipping) return;
    if (@available(iOS 11.0, *)) {
        if (self.hiddenMoveTopAnchor) {
            CGFloat guideY = CGRectGetMaxY(self.superview.safeAreaLayoutGuide.layoutFrame);
            CGFloat viewY = CGRectGetHeight(self.superview.bounds);
            self._bottomConstraint.constant = hidden ? guideY - viewY : 0;
        }
    }
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    if (self.isHidden) {
        size.height = 0;
    }
    return size;
}
    
@end
