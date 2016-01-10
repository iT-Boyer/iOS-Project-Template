
#import "MBTableHeaderFooterView.h"
#import "UIView+RFAnimate.h"
#import "RFKVOWrapper.h"

@implementation MBTableHeaderFooterView
RFInitializingRootForUIView

- (void)onInit {
}

- (void)afterInit {
    [self RFAddObserver:self forKeyPath:@keypath(self, contentView.bounds) options:NSKeyValueObservingOptionNew queue:nil block:^(MBTableHeaderFooterView *observer, NSDictionary *change) {
        [observer updateHeight];
    }];
}

- (void)updateHeight {
    [self layoutIfNeeded];
    self.height = self.contentView.height;
    _dout_float(self.height)
    UITableView *tb = (id)self.superview;
    RFAssert([tb isKindOfClass:[UITableView class]], @"MBTableHeaderFooterView’s superview must be a tableView.");
    if (tb.tableHeaderView == self) {
        tb.tableHeaderView = self;
    }

    if (tb.tableFooterView == self) {
        tb.tableFooterView = self;
    }
}

- (void)updateHeightAnimated:(BOOL)animated {
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animated:animated beforeAnimations:nil animations:^{
        [self updateHeight];
    } completion:nil];
}

- (void)setupAsHeaderViewToTableView:(UITableView *)tableView {
    if (tableView.tableHeaderView != self) {
        [self removeFromSuperview];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        self.translatesAutoresizingMaskIntoConstraints = YES;
    }
    tableView.tableHeaderView = self;
}

- (void)setupAsFooterViewToTableView:(UITableView *)tableView {
    if (tableView.tableFooterView != self) {
        [self removeFromSuperview];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        self.translatesAutoresizingMaskIntoConstraints = YES;
    }
    tableView.tableFooterView = self;
}

@end
