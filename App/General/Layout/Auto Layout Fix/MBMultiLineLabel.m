
#import "MBMultiLineLabel.h"
#import "MBLayoutConstraint.h"

@implementation MBMultiLineLabel
RFInitializingRootForUIView

- (void)onInit {
}

- (void)afterInit {
    // Nothing
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.preferredMaxLayoutWidth = CGRectGetWidth(bounds);
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    _dout_size(size)
    if (size.width == 0) {
        size.width = self.preferredMaxLayoutWidth;
    }

    if (size.height < self.minHeight) {
        size.height = self.minHeight;
    }

    if (self.collapseVerticalMarginWhenEmpty) {
        BOOL expand = (size.height > 0);
        self.topMargin.expand = expand;
        self.bottomMargin.expand = expand;
    }

    _dout_size(size)
    return size;
}

@end
