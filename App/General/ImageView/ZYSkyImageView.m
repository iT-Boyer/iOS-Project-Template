
#import "ZYSkyImageView.h"
#import "UIView+RFAnimate.h"
#import "RFKVOWrapper.h"

@interface ZYSkyImageView ()
@property (strong, nonatomic) id scrollObserver;
@end

@implementation ZYSkyImageView
RFUIInterfaceOrientationSupportDefault
RFInitializingRootForUIView

- (void)onInit {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.autoresizesSubviews = NO;
}

- (void)afterInit {
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        if (_scrollView) {
            [_scrollView RFRemoveObserverWithIdentifier:self.scrollObserver];
        }

        _scrollView = scrollView;

        if (scrollView) {
            self.scrollObserver = [scrollView RFAddObserver:self forKeyPath:@keypath(scrollView, contentOffset) options:NSKeyValueObservingOptionNew queue:nil block:^(ZYSkyImageView *observer, NSDictionary *change) {
                [observer updateContentOffset];
            }];
        }
    }
}

- (void)layoutSubviews {
    _dout_float(self.height)
    if (!self.scrollView) {
        [super layoutSubviews];
        return;
    }

    CGFloat heightShouldBe = -self.scrollView.contentOffset.y + 20 + self.offsetAdjust;
    _dout_float(self.scrollView.contentOffset.y)
    if (heightShouldBe < 0) {
        heightShouldBe = 0;
    }
    if (self.resizeTowardsTop) {
        CGFloat bottom = self.bottomMargin;
        self.height = heightShouldBe;
        self.bottomMargin = bottom;
    }
    else {
        self.height = heightShouldBe;
    }

    [super layoutSubviews];
}

- (void)updateContentOffset {
    if (!self.scrollView) return;

    CGFloat heightShouldBe = -self.scrollView.contentOffset.y + 20 + self.offsetAdjust;
    if (heightShouldBe >= 0 || self.height > 0) {
        [self setNeedsLayout];
    }
}

- (CGSize)intrinsicContentSize {
    return self.size;
}

@end
