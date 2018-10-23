
#import "MBBadgeLabel.h"
#import <RFKit/RFGeometry.h>

@implementation MBBadgeLabel
RFInitializingRootForUIView

- (void)onInit {
    CALayer *layer = self.layer;
    layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.contentInset = UIEdgeInsetsMake(2, 4, 2, 4);
}

- (void)afterInit {
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    UIEdgeInsets inset = self.contentInset;
    size.width += inset.left + inset.right;
    size.height += inset.top + inset.bottom;
    if (size.width < size.height) {
        size.width = size.height;
    }
    return size;
}

- (void)sizeToFit {
    CGSize size = self.intrinsicContentSize;
    CGRect frame = CGRectMakeWithCenterAndSize(self.center, size);
    self.frame = frame;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.layer.cornerRadius = CGRectGetHeight(bounds) / 2.;
}

- (void)updateCount:(long)count {
    self.text = @(count).stringValue;
    self.hidden = count == 0;
}

@end
