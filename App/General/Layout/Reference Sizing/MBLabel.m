
#import "MBLabel.h"
#import <RFAlpha/RFKVOWrapper.h>
#import <RFKit/UIView+RFAnimate.h>

@interface MBLabel ()
@property (nonatomic, strong) id referenceTargetSizeChangeObserver;
@end

@implementation MBLabel
RFInitializingRootForUIView
- (void)onInit {

}

- (void)afterInit {
    // Nothing
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.fontReferenceSize = self.font.pointSize;
}

- (void)setReferenceSizingFrameView:(UIView *)referenceSizingFrameView {
    if (_referenceSizingFrameView != referenceSizingFrameView) {
        if (_referenceSizingFrameView) {
            [_referenceSizingFrameView RFRemoveObserverWithIdentifier:self.referenceTargetSizeChangeObserver];
        }
        _referenceSizingFrameView = referenceSizingFrameView;
        if (referenceSizingFrameView) {
            @weakify(self);
            self.referenceTargetSizeChangeObserver = [referenceSizingFrameView RFAddObserver:self forKeyPath:@keypath(referenceSizingFrameView, size) options:NSKeyValueObservingOptionNew queue:nil block:^(id observer, NSDictionary *change) {
                @strongify(self);
                [self setNeedsUpdateReferenceSize];
            }];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
     [self setNeedsUpdateReferenceSize];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) {
        [self setNeedsUpdateReferenceSize];
    }
}

- (void)setNeedsUpdateReferenceSize {
    if (self.referenceSizingFrameView) {
        self.referenceSizingConstant = self.referenceSizingFrameView.width;
    }
}

- (void)setReferenceSizingConstant:(CGFloat)referenceSizingConstant {
    if (_referenceSizingConstant != referenceSizingConstant) {
        if (self.referenceSize
            && self.fontReferenceSize) {
            UIFont *ctFont = self.font;

            self.font = [ctFont fontWithSize:self.fontReferenceSize * RFReferenceSizeRate(self.referenceSize, referenceSizingConstant, self.referenceSizingFactor)];
        }
        _referenceSizingConstant = referenceSizingConstant;
    }
}

@end
