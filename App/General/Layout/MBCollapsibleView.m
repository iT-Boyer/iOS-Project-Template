
#import "MBCollapsibleView.h"
#import "UIView+RFAnimate.h"

@implementation MBCollapsibleView
RFInitializingRootForUIView

- (void)onInit {
    self.clipsToBounds = YES;
    _expand = YES;
    _expandedWidth = UIViewNoIntrinsicMetric;
    _expandedHeight = UIViewNoIntrinsicMetric;
}

- (void)afterInit {
    // Nothing
}

- (void)setHorizontal:(BOOL)horizontal {
    _horizontal = horizontal;
    [self invalidateIntrinsicContentSize];
}

- (void)setExpand:(BOOL)expand {
    _expand = expand;
    if (self.hiddenWhenContracted) {
        self.hidden = !expand;
    }
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    if (self.horizontal) {
        if (!self.expand) {
            size.width = self.contractedWidth;
        }
        else if (!self.useIntrinsicExpandSize) {
            size.width = self.expandedWidth;
        }
    }
    else {
        if (!self.expand) {
            size.height = self.contractedHeight;
        }
        else if (!self.useIntrinsicExpandSize) {
            size.height = self.expandedHeight;
        }
    }
    return size;
}

@end
